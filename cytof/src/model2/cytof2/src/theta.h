void update_theta(State &state, const Data &y, const Prior &prior, const Fixed &fixed_param, bool show_timings) {
  std::clock_t start_time;

  if (show_timings) start_time = std::clock();
  if (!fixed_param.beta_all) update_beta(state, y, prior);
  if (show_timings) print_time("beta", start_time);

  if (show_timings) start_time = std::clock();
  if (!fixed_param.gams_0) update_gams0(state, y, prior);
  if (show_timings) print_time("gams_0", start_time);

  if (show_timings) start_time = std::clock();
  if (!fixed_param.mus) update_mus(state, y);
  if (show_timings) print_time("mus", start_time);

  if (!fixed_param.sig2) update_sig2(state, y, prior);

  //if (!fixed_param.tau2) update_tau2(state, y, prior);
  if (!fixed_param.tau2_0) update_tau2_z(state, y, prior, 0);
  if (!fixed_param.tau2_1) update_tau2_z(state, y, prior, 1);

  //if (!fixed_param.psi) update_psi(state, y, prior);
  for (int t=0; t<5; t++) {
    if (!fixed_param.psi_0) update_psi_z(state, y, prior, 0);
    if (!fixed_param.psi_1) update_psi_z(state, y, prior, 1);
  }

  if (!fixed_param.Z) {
    //update_v(state, y, prior);
    if (show_timings) start_time = std::clock();
    update_v_jointly(state, y, prior);
    if (show_timings) print_time("v", start_time);
    update_Z(state, y, prior);

    if (show_timings) start_time = std::clock();
    update_H(state, y, prior);
    if (show_timings) print_time("H", start_time);
    update_Z(state, y, prior);
  }

  if (show_timings) start_time = std::clock();
  if (!fixed_param.lam) update_lam(state, y, prior);
  if (show_timings) print_time("lam", start_time);
  
  if (show_timings) start_time = std::clock();
  if (!fixed_param.W) update_W(state, y, prior);
  if (show_timings) print_time("W", start_time);

  if (show_timings) start_time = std::clock();
  if (!fixed_param.missing_y) {
    update_missing_y(state, y, prior);
  }
  if (show_timings) print_time("missing_y", start_time);
}

void update_theta_no_K(State &state, const Data &y, const Prior &prior, const Fixed &fixed_param, bool show_timings) {
  std::clock_t start_time;

  if (show_timings) start_time = std::clock();
  if (!fixed_param.gams_0) update_gams0(state, y, prior);
  if (show_timings) print_time("gams_0", start_time);

  if (show_timings) start_time = std::clock();
  if (!fixed_param.mus) update_mus(state, y);
  if (show_timings) print_time("mus", start_time);

  if (!fixed_param.sig2) update_sig2(state, y, prior);

  //if (!fixed_param.tau2) update_tau2(state, y, prior);
  if (!fixed_param.tau2_0) update_tau2_z(state, y, prior, 0);
  if (!fixed_param.tau2_1) update_tau2_z(state, y, prior, 1);

  //if (!fixed_param.psi) update_psi(state, y, prior);
  for (int t=0; t<5; t++) {
    if (!fixed_param.psi_0) update_psi_z(state, y, prior, 0);
    if (!fixed_param.psi_1) update_psi_z(state, y, prior, 1);
  }



  if (!fixed_param.Z) {
    //update_v(state, y, prior);
    if (show_timings) start_time = std::clock();
    update_v_jointly(state, y, prior);
    if (show_timings) print_time("v", start_time);
    update_Z(state, y, prior);

    if (show_timings) start_time = std::clock();
    update_H(state, y, prior);
    if (show_timings) print_time("H", start_time);
    update_Z(state, y, prior);
  }

  if (show_timings) start_time = std::clock();
  if (!fixed_param.lam) update_lam(state, y, prior);
  if (show_timings) print_time("lam", start_time);
  
  if (show_timings) start_time = std::clock();
  if (!fixed_param.W) update_W(state, y, prior);
  if (show_timings) print_time("W", start_time);
}

void substitute_training_params_not_depending_K(State &theta_k, const State &state) {
  theta_k.mus = state.mus;
  theta_k.sig2 = state.sig2;
  theta_k.gams_0 = state.gams_0;
  theta_k.psi = state.psi;
  theta_k.tau2 = state.tau2;
  theta_k.beta_1 = state.beta_1;
  theta_k.beta_0 = state.beta_0;
  theta_k.x = state.x;
  theta_k.betaBar_0 = state.betaBar_0;
}
