using System;

class MatrixOperations
{
    static void Main()
    {
        const int n = 100;
        float[,] matrixA = new float[n, n];
        float[,] matrixB = new float[n, n];
        float[,] result = new float[n, n];

        // Initialize matrices
        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < n; j++)
            {
                matrixA[i, j] = (float)(i + 1 + j + 1); // Adjust for zero-based index
                matrixB[i, j] = (float)((i + 1) * (j + 1)); // Adjust for zero-based index
            }
        }

        // Matrix multiplication
        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < n; j++)
            {
                result[i, j] = 0.0f;
                for (int k = 0; k < n; k++)
                {
                    result[i, j] += matrixA[i, k] * matrixB[k, j];
                }
            }
        }

        Console.WriteLine("Matrix multiplication completed");
        Console.WriteLine("Result(1,1) = " + result[0, 0]); // Adjust for zero-based index
    }
}
```