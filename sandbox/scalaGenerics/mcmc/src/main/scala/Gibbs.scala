package mcmc

import java.util.Calendar

trait Gibbs extends MCMC {
  // State
  type State

  // Substate to monitor. By default, it is the entire state.
  // thin period is 1 by default
  type Substate1
  def deepcopy1(s:State): Substate1
  val thin1:Int = 1


  // Optional substates to monitor.
  // thin period is 0 by default. i.e. no thinning.
  type Substate2
  def deepcopy2(s:State): Option[Substate2] = None
  val thin2:Int = 0

  type Substate3
  def deepcopy3(s:State): Option[Substate3] = None
  val thin3:Int = 0


  // Update function
  def update(s: State): Unit

  type Output = (List[Substate1], List[Substate2], List[Substate3])

  def gibbs(s: State, 
            niter:Int, nburn:Int, printProgress:Boolean=true,
            _out: Output = (List(), List(), List())): Output = {
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
      lazy val newOut1:List[Substate1] = if (thin1 > 0 && niter % thin1 == 0) {
        deepcopy1(s) :: _out._1
      } else _out._1

      lazy val newOut2:List[Substate2] = if (thin2 > 0 && niter % thin2 == 0) {
        deepcopy2(s) match {
          case Some(x) => x :: _out._2
          case None => _out._2
        }
      } else _out._2

      lazy val newOut3:List[Substate3] = if (thin3 > 0 && niter % thin3 == 0) {
        deepcopy3(s) match {
          case Some(x) => x :: _out._3
          case None => _out._3
        }
      } else _out._3

      lazy val newOut = (newOut1, newOut2, newOut3)
      gibbs(s, niter - 1, 0, printProgress, newOut)
    } else _out
  }
}

