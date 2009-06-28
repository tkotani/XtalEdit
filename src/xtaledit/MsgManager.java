package xtaledit;
import java.awt.Component;
import java.util.StringTokenizer;

/*
 * Created on 2003/07/29
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */

/**
 * @author Goto Ryuichi
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */

public class MsgManager {
	private final static boolean PRTEXCEPT = true; // PRTEXCEPT_CHANGE

	/**
	* Print Message & Error dialog
	*/
	public final static void errDialog(
		Object obj,
		String msg,
		Exception e,
		Component com) {
		print(obj, msg, e);
		Udialog.err(com, msg + "\n" + e);
	}
	public final static void errDialog(
		Object obj,
		String msg,
		Error e,
		Component com) {
		print(obj, msg, e);
		Udialog.err(com, msg + "\n" + e);
	}
	public final static void errDialog(
		String msg,
		Exception e,
		Component com) {
		print(msg, e);
		Udialog.err(com, msg + "\n" + e);
	}
	public final static void errDialog(Object obj, String msg, Component com) {
		print(obj, msg);
		Udialog.err(com, msg);
	}

	/**
	* Print Message
	*/
	public final static void print(Object obj, String msg, Exception e) {
		System.out.println(obj.getClass().getName() + ": " + msg);
		// + "\n" + e.toString());
		prtExceptErr(e);
	}
	public final static void print(Object obj, String msg, Error e) {
		System.out.println(obj.getClass().getName() + ": " + msg);
		//  + "\n" + e.toString());
		prtExceptErr(e);
	}
	public final static void print(Object obj, Exception e) {
		System.out.println(obj.getClass().getName());
		//  + "\n" + e.toString());
		prtExceptErr(e);
	}
	public final static void print(String msg, Exception e) {
		System.out.println(msg); //  + "\n" + e.toString());
		prtExceptErr(e);
	}
	public final static void print(Object obj, String msg) {
		System.out.println(obj.getClass().getName() + ": " + msg);
	}
	public final static void print(String msg) {
		System.out.println(msg);
	}

	/**
	* Print exception/error-Part
	*/
	private final static void prtExceptErr(Exception e) {
		//System.out.println(e.toString());  // Only msg  (ref.  ... msg + "\n" + e.toString());)
		e.printStackTrace(); // msg & stack
	}
	private final static void prtExceptErr(Error e) {
		//System.out.println(e.toString());
		e.printStackTrace();
	}

	// ref.
	// .getMessage()
	//println -> add \n  print -> None \n
	//System.err.print(msg);
	//System.out.print(msg);
	//System.out.flush();

	/**
	* Get Lower class name
	*/
	protected String getClassName() {
		StringTokenizer tokens = new StringTokenizer(getClass().getName(), ".");

		// get last of tokens
		while (tokens.countTokens() != 1) {
			tokens.nextToken();
		}
		return tokens.nextToken();
	}

}
