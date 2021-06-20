using System;

public class NullOperators{
  public static int Main(string[] args){
    System.Text.StringBuilder sb = null;
    string s = sb?.ToString();
    if(s == null)
        Console.Write("This works when the left operand is null.\n");
    return 0;
  }
}
