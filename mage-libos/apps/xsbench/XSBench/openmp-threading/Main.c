#include "XSbench_header.h"

#ifdef MPI
#include<mpi.h>
#endif

size_t getFaultTime(){
  FILE *fp = fopen("/proc/self/stat", "r");
  if(fp == NULL) {
    fprintf(stderr, "Could not open /proc/self/stat to read memory usage\n");
    exit(1);
  }

  unsigned long unused;

  unsigned long stime;
  char buff[20];
  if (fscanf(fp, "%d %s %c %d %d %d %d %d %lu %lu %lu %lu %lu %lu %lu ...", 
    &unused, &buff, &unused, &unused, &unused, &unused, &unused, &unused, &unused, &unused, &unused, &unused, &unused, &unused, &stime) != 15) {
	  perror("");
	  exit(1);
  }

  (void)unused;
  fclose(fp);
  return stime;

}

size_t getMajor(){
  FILE *fp = fopen("/proc/self/stat", "r");
  if(fp == NULL) {
    fprintf(stderr, "Could not open /proc/self/stat to read memory usage\n");
    exit(1);
  }

  unsigned long unused;

  unsigned long major;
  char buff[20];
  if (fscanf(fp, "%d %s %c %d %d %d %d %d %lu %lu %lu %lu ...", 
    &unused, &buff, &unused, &unused, &unused, &unused, &unused, &unused, &unused, &unused, &unused, &major) != 12) {
	  perror("");
	  exit(1);
  }

  (void)unused;
  fclose(fp);
  return major;
}


int main( int argc, char* argv[] )
{
	// =====================================================================
	// Initialization & Command Line Read-In
	// =====================================================================
	int version = 20;
	int mype = 0;
	double omp_start, omp_end;
	int nprocs = 1;
	unsigned long long verification;

	#ifdef MPI
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
	MPI_Comm_rank(MPI_COMM_WORLD, &mype);
	#endif

	#ifdef AML
	aml_init(&argc, &argv);
	#endif

	// Process CLI Fields -- store in "Inputs" structure
	Inputs in = read_CLI( argc, argv );

	// Set number of OpenMP Threads
	#ifdef OPENMP
	omp_set_num_threads(in.nthreads); 
	#endif

	// Print-out of Input Summary
	if( mype == 0 )
		print_inputs( in, nprocs, version );

	// =====================================================================
	// Prepare Nuclide Energy Grids, Unionized Energy Grid, & Material Data
	// This is not reflective of a real Monte Carlo simulation workload,
	// therefore, do not profile this region!
	// =====================================================================
	
	SimulationData SD;

	// If read from file mode is selected, skip initialization and load
	// all simulation data structures from file instead
	if( in.binary_mode == READ )
		SD = binary_read(in);
	else
		SD = grid_init_do_not_profile( in, mype );

	// If writing from file mode is selected, write all simulation data
	// structures to file
	if( in.binary_mode == WRITE && mype == 0 )
		binary_write(in, SD);


	// =====================================================================
	// Cross Section (XS) Parallel Lookup Simulation
	// This is the section that should be profiled, as it reflects a 
	// realistic continuous energy Monte Carlo macroscopic cross section
	// lookup kernel.
	// =====================================================================

	if( mype == 0 )
	{
		printf("\n");
		border_print();
		center_print("SIMULATION", 79);
		border_print();
	}
	size_t maj_start = getMajor();
	size_t fault_time_start = getFaultTime();

	// Start Simulation Timer
	omp_start = get_time();

	// Run simulation
	if( in.simulation_method == EVENT_BASED )
	{
		if( in.kernel_id == 0 )
			verification = run_event_based_simulation(in, SD, mype);
		else if( in.kernel_id == 1 )
			verification = run_event_based_simulation_optimization_1(in, SD, mype);
		else
		{
			printf("Error: No kernel ID %d found!\n", in.kernel_id);
			exit(1);
		}
	}
	else
		verification = run_history_based_simulation(in, SD, mype);

	if( mype == 0)	
	{	
		printf("\n" );
		printf("Simulation complete.\n" );
	}

	// End Simulation Timer
	omp_end = get_time();

	// =====================================================================
	// Output Results & Finalize
	// =====================================================================

	// Final Hash Step
	verification = verification % 999983;

	// Print / Save Results and Exit
	int is_invalid_result = print_results( in, mype, omp_end-omp_start, nprocs, verification );

	#ifdef MPI
	MPI_Finalize();
	#endif

	#ifdef AML
	aml_finalize();
	#endif
	size_t maj_end = getMajor();
	size_t fault_time_end = getFaultTime();
	printf("Major: %lu\n", maj_end - maj_start);
	printf("Fault time: %lu\n", fault_time_end - fault_time_start);

	return is_invalid_result;
}
