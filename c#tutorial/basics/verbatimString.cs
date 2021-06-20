using System;

public class VerbatimStringTest{
  public static int Main(string [] args){
    string sample = @"\\server\fileshare\helloworld.cs";
    string multiLines = @"This is the first line,
           This is the second line.
             This is the third, also the last line.\n";
    Console.Write(sample + "\n" + multiLines);
    return 0;
  }
}
