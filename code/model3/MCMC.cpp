#include<functional>
#include<ctime>
#include<array>
#include<iostream>

template<typename S, int B>
std::array<S,B> gibbs(S init, std::function<S(S)> update, int burn, int printEvery) {
  S out[B];
  out[0] = init;

  for (int i=0; i<B+burn; i++) {
    if (i <= burn) {
      out[0] = update(out[0]);
    } else {
      out[i-burn] = update(out[i-burn-1]);
    }

    if (printEvery > 0 && (i+1) % printEvery == 0) {
      std::cout << "\rProgress:  " << i+1 << "/" << B+burn << "\t";
    }
  }

  if (printEvery > 0) std::cout << std::endl;
  return out;

}

/* test:
struct State { int x; }
auto init = State{1}
auto update = [](State s) {return State{s.x + 1};}
gibbs<State,100>(init, update, 10, 0)
 */
