using System;

public class InterpolateString{
  public static int Main(string[] args){
    int x = 2;
    string sample = $@"This spans
    {x} lines.";
    Console.WriteLine(sample);
    return 0;
  }
}
