#include <vector>

struct Bla {
  Bla(int x, int y) : vec_x(2), vec_y(2) {
    for (int z=0; z<2; z++) {
      vec_x.resize(x);
      vec_y.resize(y);
    }
  }
  std::vector<int> vec_x;
  std::vector<int> vec_y;
}

auto bla = Bla(3,5)
