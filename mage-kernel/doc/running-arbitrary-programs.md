# Running Arbitrary Programs

Please inspect the benchmarking scripts for an idea how to run arbitrary programs. 

The current version of Mage-Linux doesn't support dynamically linked libraries. 
Please make sure all of your programs are statically linked (`dlopen` calls are allowed). 
Remember that even the "built in" libraries need to be statically compiled; 
this can cause problems when running OpenMP applications, since many distributions don't 
package a static-library version of `libgomp`! (which is needed for OpenMP). 
You'll have to compile and install libgomp yourself. 
SOSP evaluators: we have already done this in the test environments. 
