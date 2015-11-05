#include "PseudoInverseSVD.hpp"
#include <time.h>
#include <sys/time.h>
#include <string>	// stod (-std=c++11)
#include <stdio.h>	// std::fopen, std::fclose


using namespace eigen;
using namespace Eigen;
using namespace std;

double get_wall_time();
double get_cpu_time();
MatrixXd readMatrixFromFile(string * , /*MatrixXd & ,*/ int, int);


int main()
{
  string* filename = new string("./matrix_files/matrix12_1.txt");
  MatrixXd M;
  M = readMatrixFromFile(filename, 12, 12);
  MatrixXd Minv = MatrixXd::Random(12,12);
  double wall_time0 = get_cpu_time();
  pseudo_inverse_svd(M, Minv);
  double wall_time1 = get_cpu_time();
  MatrixXd errM = MatrixXd::Identity(12,12)-M*Minv;
  cout<<"Error matrix: "<<endl<< errM <<endl;
  cout<<"norm(I - M*Minv, inf) = "<< errM.lpNorm<Infinity>()  <<endl;
  cout<<"Average of elements in the matrix = "<< errM.mean() <<endl;
  cout<<"Time elapsed = "<< wall_time1 - wall_time0 <<"s"<<endl;
  return 0;
}

/**========================================readMatrixFromFile========================================//
 * Initialize matrix M from a file
 ***********************************
 * @param	filename:	filename which contains the matrix
 * @param 	row:		#rows of the matrix
 * @param 	col:		#cols of the matrix
 * @return 	M:		row by col matrix read from filename
 */
MatrixXd readMatrixFromFile(string * filename,/* MatrixXd & M,*/ int row, int col){
  char buffer[1024];
  string* line = new string();
  char* ptr;
  MatrixXd M(row,col);
  FILE* f_input = fopen(filename->c_str(),"r");
  if(f_input == NULL) exit(1);

  for(int r = 0 ; r < row ; r ++){
    if(fgets(buffer, 1024, f_input) == NULL){
      cerr<<"Matrix dimension dismatch!!!"<<endl;
      exit(0);
    }
    *line = string(buffer);
    for(int c = 0 ; c < col ; c ++){
      // The elements in the matrix should be seperated
      // by space(s) or tab(s), otherwise when there are
      // non-digits before the value stod does not work!!!
      M(r,c) = strtod(line->c_str(), &ptr);
      // stod() does not work here when the value is too close to zero!!!
      *line = string(ptr);
    }
  }
  //cout<< "The matrix read in is : ("<< row <<" rows and "<< col <<" cols)"<<endl;
  //cout<< M <<endl;
  delete line;
  fclose(f_input);
  return M;
}


/**
 * Get wall time and CPU time  
 */
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
