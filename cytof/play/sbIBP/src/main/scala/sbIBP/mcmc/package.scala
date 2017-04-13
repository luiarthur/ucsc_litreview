package sbIBP

package object mcmc {

  def gibbs[S](
    init:S, update:S=>S, 
    B:Int, burn:Int, printEvery:Int=0
  ) = {

    def loop(chain:List[S],i:Int): List[S] = {
      if (printEvery > 0 && i % printEvery == 0) 
        print("\rProgress: " + i +"/"+ (B+burn) + "\t")

      if (i < B + burn) {
        val newState = {
          if (i <= burn) List( update(chain.head) ) else
            update(chain.head) :: chain
        }
        loop(newState,i+1)
      } else chain
    }

    loop(List(init),0)
  }

}
