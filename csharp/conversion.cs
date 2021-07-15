using System;

public class Conversion{
    public static void Main(string[] args){
        int i1 = 100000001;
        float f = i1;
        int i2 = (int)f;
        Console.WriteLine(i1);
        Console.WriteLine(i2);
    }
}