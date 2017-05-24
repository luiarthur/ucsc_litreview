// Updating psi_j. See Section 5.2 of manual.

double log_fc_psi(State &state, const Data &y, const Prior &prior, 
                  const int j, const int k);



void update_psi(State &state, const Data &y, const Prior &prior, 
                const int j, const int k) {

  //auto log_fc = [&](double psi_j) {
  //  return log_fc_psi(psi_j, state, y, prior, j, k);
  //};

  //metropolis::uni(state.psi(j), log_fc, prior.cs_psi);
};
