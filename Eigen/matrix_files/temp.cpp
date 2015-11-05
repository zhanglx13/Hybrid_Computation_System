// stod example
#include <iostream>   // std::cout
#include <string>     // std::string, std::stod
#include <stdio.h>
using namespace std;

int main ()
{
  std::string orbits ("3e-10 29.53");
  std::string::size_type sz;     // alias of size_t

  double earth = stod (orbits,&sz);
  double moon = stod (orbits.substr(sz));
  std::cout << earth << endl;
  return 0;
}
