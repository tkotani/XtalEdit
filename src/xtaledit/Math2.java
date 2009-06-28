

package xtaledit;
/*
 * Created on 2003/06/24
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */

/**
 * @author Sora Takefumi
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
/**
*    Math function
*/
public class Math2 extends Object {
    private Math2() {
    }

    /**
    *    Limit val
    */
    public final static byte BYTE_MAX = 127; // max value of a signed char 
    public final static byte BYTE_MIN = -128; // Min value of a signed char 
    public final static short SHORT_MAX = 32767; // max decimal value of a short 
    public final static short SHORT_MIN = -32768; // Min decimal value of a short 
    public final static int INT_MAX = 2147483647; // Max decimal value of an int 
    public final static int INT_MIN = -2147483648; // Min decimal value of an int 
    //public final static long  LONG_MAX  =   9223372036854775807; // Max decimal value of a long 
    //public final static long  LONG_MIN  =  -9223372036854775808; // Min decimal value of a long 

    public final static float FLOAT_MAX = Float.POSITIVE_INFINITY; //  Infinity
    public final static float FLOAT_MIN = Float.NEGATIVE_INFINITY; // -Infinity
    public final static double DOUBLE_MAX = Double.POSITIVE_INFINITY;
    public final static double DOUBLE_MIN = Double.NEGATIVE_INFINITY;
    //Float.MIN_VALUE 1.4E-45    Float.MAX_VALUE  3.4028235E38          

    //public final static float M_PI   = 3.14159265f;
    //public final static float M_PI_2 = 1.57079632f;
    //public final static float SQRT2    = 1.41421356237309504880f;

    /**
    *    math(int)
    */
    public static synchronized int sgn(int x) {
        int v = (x >= 0 ? 1 : -1);
        return (v);
    }
    public static synchronized int abs(int x) {
        int v = (x >= 0 ? x : -x);
        return (v);
    }
    public static synchronized int min(int a, int b) {
        int v = ((a > b) ? b : a);
        return (v);
    }
    public static synchronized int max(int a, int b) {
        int v = ((a > b) ? a : b);
        return (v);
    }
    public static synchronized int min(int a, int b, int c) {
        int v = ((((a < b) ? a : b) < c) ? ((a < b) ? a : b) : c);
        return (v);
    }
    public static synchronized int max(int a, int b, int c) {
        int v = ((((a > b) ? a : b) > c) ? ((a > b) ? a : b) : c);
        return (v);
    }

    /**
    *    math(float)
    */
    public static synchronized int sgn(float x) {
        int v = (x >= 0 ? 1 : -1);
        return (v);
    }
    public static synchronized float abs(float x) {
        float v = (x >= 0 ? x : -x);
        return (v);
    }
    public static synchronized float min(float a, float b) {
        float v = ((a > b) ? b : a);
        return (v);
    }
    public static synchronized float max(float a, float b) {
        float v = ((a > b) ? a : b);
        return (v);
    }
    public static synchronized float min(float a, float b, float c) {
        float v = ((((a < b) ? a : b) < c) ? ((a < b) ? a : b) : c);
        return (v);
    }
    public static synchronized float max(float a, float b, float c) {
        float v = ((((a > b) ? a : b) > c) ? ((a > b) ? a : b) : c);
        return (v);
    }

    /**
    *    math(double)
    */
    public static synchronized int sgn(double x) {
        int v = (x >= 0 ? 1 : -1);
        return (v);
    }
    public static synchronized double abs(double x) {
        double v = (x >= 0 ? x : -x);
        return (v);
    }
    public static synchronized double min(double a, double b) {
        double v = ((a > b) ? b : a);
        return (v);
    }
    public static synchronized double max(double a, double b) {
        double v = ((a > b) ? a : b);
        return (v);
    }
    public static synchronized double min(double a, double b, double c) {
        double v = ((((a < b) ? a : b) < c) ? ((a < b) ? a : b) : c);
        return (v);
    }
    public static synchronized double max(double a, double b, double c) {
        double v = ((((a > b) ? a : b) > c) ? ((a > b) ? a : b) : c);
        return (v);
    }

    /**
    *    conv to val
    */
    public static synchronized int s_i(String s) {
        return (Integer.valueOf(s).intValue());
    }
    public static synchronized long s_l(String s) {
        return (Long.valueOf(s).longValue());
    }
    public static synchronized float s_f(String s) {
        return (Float.valueOf(s).floatValue());
    }
    public static synchronized double s_d(String s) {
        return (Double.valueOf(s).doubleValue());
    }

    /**
    *    conv to string
    */
    public static synchronized String i_s(int i) {
        String s = new String(Integer.toString(i));
        return (s);
    }
    public static synchronized String l_s(long l) {
        String s = new String(Long.toString(l));
        return (s);
    }
    public static synchronized String f_s(float f) {
        String s = new String(Float.toString(f));
        return (s);
    }
    public static synchronized String d_s(double f) {
        String s = new String(Double.toString(f));
        return (s);
    }
    //ref. int i = Integer.parseInt(String s)  long l = Long.parseLong(s);
    //ref. Integer.toHexString(i) toBinaryString(i)

    public static synchronized long unsigned(int i) {
        //MsgManager.print("(unsigned) i=" + Integer.toHexString(i));
        long l1 = i & 0xffffffff;
        long l = (l1 << 32) >>> 32;

        //out!
        /*
        long l2 = l1 & 0x00000000ffffffff;
        long l3 = (i << 1 ) >>> 1;
        MsgManager.print("(unsigned) l=" + Long.toHexString(l) +
        " l1=" + Long.toHexString(l1) +
        " 12=" + Long.toHexString(l2) +
        " 13=" + Long.toHexString(l3) );
             //i=7ffffb80
             //l=7ffffb80 l1=7ffffb80 12=7ffffb80 13=7ffffb80
             //i=affff900
             //l=affff900 l1=ffffffffaffff900 12=ffffffffaffff900 13=2ffff900
        */

        return (l);
    }

    /**
    *    num check
    */
    public static synchronized boolean chk_digit(String str) {
        String s = str.toString();
        s.trim();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '+' || c == '-') {
                if (i == 0)
                    continue;
                else
                    return (false);
            }
            if (c == '.') {
                return (false);
            }
            if (Character.isDigit(c))
                continue;
            return (false);
        }
        return (true);
    }

    /**
    *    real check
    */
    public static synchronized boolean chk_real(String str) {
        String s = str.toString();
        s.trim();
        int pchk = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '+' || c == '-') {
                if (i == 0)
                    continue;
                else
                    return (false);
            }
            if (c == '.') {
                if (pchk == 0) {
                    pchk = 1;
                    continue;
                } else {
                    return (false);
                }
            }
            if (Character.isDigit(c))
                continue;
            return (false);
        }
        return (true);
    }
    //ref. Character.isLetterOrDigit(c)
    //samp. "smiles".substring(1, 5) -> "mile"
}
