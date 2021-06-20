using System;

public class OverflowCheck{
    static int Main(string [] args){
      int a = 1000000, b = 1000000;
      // This will lead a oveflow Exception
      int c = checked(a * b);
      int d = int.MinValue;
      --d;
      return 0;
    }
}
