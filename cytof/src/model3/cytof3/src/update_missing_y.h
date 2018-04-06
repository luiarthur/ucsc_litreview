#ifndef UPDATE_MISSING_Y_H
#define UPDATE_MISSING_Y_H

void update_missing_yinj(State &state, const Data &data, const Prior &prior, const Locked &locked, int i, int n, int j){
}

void update_missing_y(State &state, const Data &data, const Prior &prior, const Locked &locked){
  for (int i=0; i < data.I; i++) {
    for (int j=0; j < data.J; j++) {
      for (int n=0; n < data.N[i]; n++) {
        if (data.M[i](n, j) == 1) { // 1 ->  y_inj is missing
          update_missing_yinj(state, data, prior, locked, i, n, j);
        }
      }
    }
  } 
}

#endif
