package mcmc

import java.util.Calendar

trait Gibbs extends MCMC {
  // State
  type State
  def deepcopy(s:State): State


  // Substate to monitor. By default, it is the entire state.
  // thin period is 1 by default
  type Substate1 = State
  def deepcopy1(m:State): Substate1
  val thin1:Int = 1


  // Optional substates to monitor.
  // thin period is 0 by default. i.e. no thinning.
  type Substate2
  def deepcopy2(m:State): Substate2
  val thin2:Int = 0

  type Substate3
  def deepcopy3(m:State): Substate3
  val thin3:Int = 0


  // Update function
  def update(s: State): Unit

  type Output = (List[Substate1], List[Substate2], List[Substate3])

  def gibbs(s: State, 
            niter:Int, nburn:Int, printProgress:Boolean=true,
            _out: Output): Output = {
    // Update the current state
    update(s)

    // Print progress
    if (printProgress && (niter + nburn) % 100 == 0) {
      println(s"Progress: ${niter+nburn} iterations remaining -- ${Calendar.getInstance.getTime}")
    }

    // Repeat if still burning
    if (nburn > 0) {
      gibbs(s, niter, nburn - 1, printProgress, _out)
    } else if (niter > 0) {
      lazy val newOut1 = 
        if (niter % thin1 == 0) deepcopy1(s) :: _out._1 else _out._1
      lazy val newOut2 =
        if (niter % thin2 == 0) deepcopy2(s) :: _out._2 else _out._2
      lazy val newOut3 =
        if (niter % thin3 == 0) deepcopy3(s) :: _out._3 else _out._3

      lazy val newOut = (newOut1, newOut2, newOut3)
      gibbs(s, niter - 1, 0, printProgress, newOut)
    } else _out
  }
}

