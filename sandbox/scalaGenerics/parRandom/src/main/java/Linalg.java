package parRandom;

// These implementations are here for reference. They're not currently used.

public class Linalg {
  // Surprisingly not faster than scala version
  public static double[][] choleskyL(double[][] A) {
    int n = A.length;
    double[][] L = new double[n][n];

    for (int i=0; i<n; i++) {
      for (int j=0; j<=i; j++) {
        double x=0;
        for (int k=0; k<i; k++) { x += L[i][k] * L[j][k]; }
        L[i][j] = (i == j) ? Math.sqrt(A[i][i] - x) : (A[i][j] - x) / L[j][j];
      }
    }

    return L;
  }

  // Surprisingly slower than scala version.
  public static double[] rmvnorm(double m[], double[][] S) {
    double [][] L = choleskyL(S);
    int n = m.length;
    double[] x = new double[n];
    for (int i=0; i<n; i++) {
      x[i] = m[i] + 0;
      for (int j=0; j<=i; j++) {
        double z = java.util.concurrent.ThreadLocalRandom.current().nextGaussian();
        x[i] += L[i][j] * z;
      }
    }

    return x;
  }

}
