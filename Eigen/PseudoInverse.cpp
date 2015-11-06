#include "PseudoInverseSVD.hpp"
#include <time.h>
#include <sys/time.h>
#include <string>	// stod (-std=c++11)
#include <stdio.h>	// std::fopen, std::fclose

#define M_ROW		12
#define M_COL		12
#define M_FILE		"./matrix_files/matrix12_1.txt"
#define M_INIT_FILE	"./matrix_files/matrix12_1_25bits.txt"

using namespace eigen;
using namespace Eigen;
using namespace std;

double get_wall_time();
double get_cpu_time();
MatrixXd readMatrixFromFile(string * , int, int);
template<typename DerivedA>
MatrixXd inverseIterative(const MatrixBase<DerivedA>& , const MatrixBase<DerivedA>& );


int main()
{
  // File containing M
  string* M_filename = new string(M_FILE);
  MatrixXd M = readMatrixFromFile(M_filename, M_ROW, M_COL);
  
  /* Compute the inverse using SVD decmp  */
  cout<< "Compute the inverse using SVD decmp ... "<<endl;
  MatrixXd Minv = MatrixXd::Random(M_COL, M_ROW);
  double wall_time0 = get_wall_time();
  pseudo_inverse_svd(M, Minv);
  double wall_time1 = get_wall_time();
  MatrixXd errM = MatrixXd::Identity(M_ROW,M_COL)-M*Minv;
  //  cout<<"Error matrix: "<<endl<< errM <<endl;
  cout<<"norm(I - M*Minv) = "<< errM.norm() <<endl;
  //  cout<<"mean(I - M*Minv) = "<< errM.mean() <<endl;
  cout<<"Time elapsed (wall time) = "<< wall_time1 - wall_time0 <<"s"<<endl;

  /* Compute the inverse using iterative algorithm  */
  cout<< "Compute the inverse using iterative algorithm ... "<<endl;
  string* Minit_filename = new string(M_INIT_FILE);
  Minv = readMatrixFromFile(Minit_filename, M_COL, M_ROW);
  wall_time0 = get_wall_time();
  Minv = inverseIterative(M, Minv);
  wall_time1 = get_wall_time();
  errM = MatrixXd::Identity(M_ROW,M_COL)-M*Minv;
  cout<<"norm(I - M*Minv) = "<< errM.norm() <<endl;
  //  cout<<"mean(I - M*Minv) = "<< errM.mean() <<endl;
  cout<<"Time elapsed (wall time) = "<< wall_time1 - wall_time0 <<"s"<<endl;
  cout<< Minv <<endl;


  delete M_filename;
  delete Minit_filename;
  return 0;
}


/**========================================inverseIterative========================================//
 * Compute the inverse of matrix M using iterative algorithm
 * with an initial value obtained from the analog circuitry
 * For now, only square matrices are considered.
 ************************************************************
 * @param	M:		input matrix to be inverted
 * @param 	Minit:		Initial approximation of the inverse of matrix M
 * @return 	Minv:		Inverse of matrix M
 */
template<typename DerivedA>
MatrixXd inverseIterative(const MatrixBase<DerivedA>& M, const MatrixBase<DerivedA>& Minit){
  MatrixXd Minv = Minit;	// initial value
  MatrixXd I = MatrixXd::Identity(M_ROW,M_COL);	// Identity matrix
  MatrixXd errM = I - M*Minv;	// error matrix
  double norm_2 = errM.norm();
  int num_iterations = 0;	// number of iterations
  while (norm_2 > 1e-4){
    num_iterations ++;
    Minv = Minv*(2*I - M*Minv);
    errM = I - M*Minv;
    norm_2 = errM.norm();
    cout<<"iteration "<< num_iterations <<"  norm = "<< norm_2 <<endl;
  }
  //  for(int i = 0 ; i < num_iterations ; i ++)
 
  return Minv;
}

/**========================================readMatrixFromFile========================================//
 * Initialize matrix M from a file
 ***********************************
 * @param	filename:	filename which contains the matrix
 * @param 	row:		#rows of the matrix
 * @param 	col:		#cols of the matrix
 * @return 	M:		row by col matrix read from filename
 */
MatrixXd readMatrixFromFile(string * filename, int row, int col){
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
