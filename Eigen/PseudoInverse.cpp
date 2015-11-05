#include "PseudoInverse.hpp"
#include <time.h>
#include <sys/time.h>


using namespace eigen;
using namespace Eigen;
using namespace std;
double get_wall_time();
double get_cpu_time();

int main()
{
  /* Generate input matrix */
  // Using random input matrix //
  MatrixXd M = MatrixXd::Random(16,16);
  cout<<"Input matrix M:"<<endl<< M <<endl;
  MatrixXd Minv = MatrixXd::Random(16,16);
  double wall_time0 = get_cpu_time();
  pseudo_inverse_svd(M, Minv);
  double wall_time1 = get_cpu_time();
  cout<<"Inverse of matrix M:"<<endl<< Minv <<endl;
  cout<<"I - M*Minv = "<<endl<< MatrixXd::Identity(16,16)-M*Minv <<endl;
  cout<<"Time elapsed = "<< wall_time1 - wall_time0 <<"s"<<endl;
  return 0;
}


/* Get wall time and CPU time  */
double get_wall_time()
{
  struct timeval time;
  if (gettimeofday(&time,NULL)){
    //  Handle error
    return 0;
  }
  return (double)time.tv_sec + (double)time.tv_usec * .000001;
}
double get_cpu_time()
{
  return (double)clock() / CLOCKS_PER_SEC;
}
