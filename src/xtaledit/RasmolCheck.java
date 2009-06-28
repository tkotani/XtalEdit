package xtaledit;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/*
 * Created on 2003/07/16
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

class RasmolCheck {

	public String XtalEditHome = System.getProperty("user.dir");
	public String fileSeparateChar = System.getProperty("file.separator");
	public String osName = System.getProperty("os.name"); //r-goto 2003.7.4
	public String rasmolApplication = null;
	public String PythonDir =
		XtalEditHome
			+ fileSeparateChar
			+ "UserModule"
			+ fileSeparateChar
			+ "Rasmol";

	String osPartName = null;
	Process pyps = null;
	StringBuffer pythonPrint;
	StringBuffer pythonErr;
	RasmolCheck() {

		String keyword = "No suitable";
		try {
			osPartName = osName.substring(0, 7);
		} catch (Exception ex) {
			osPartName = osName;
		}
		System.out.println(osPartName);
		if (osPartName.equals("Windows")) {
			rasmolApplication = "rasmol.exe";
		} else {
			/*
			 *  in case of UNIX
			 */
			ExecutePython exec = new ExecutePython();
			executeRasmol(XtalEditHome + fileSeparateChar + "UserModule"+fileSeparateChar + "Rasmol"+fileSeparateChar + "RasmolCheck.py");
			
		}
	}
	private void executeRasmol(String filepath) {
        
		// Execution
		File pythonfile = new File(filepath);
		System.out.println(filepath);
		if (pythonfile.exists()) {
			Runtime runtime = Runtime.getRuntime();
			String[] execCommand = new String[2];
			execCommand[0] = "python";
			execCommand[1] = filepath;
			try {
				pyps = runtime.exec(execCommand);
			} catch (IOException e1) {
				e1.printStackTrace();
			}

			// ïWèÄèoóÕãzÇ§
			Runnable stdrun = new Runnable() {
				public void run() {
					try {
						InputStream inp = pyps.getInputStream();
						DataInputStream d_inp = new DataInputStream(inp);
						BufferedReader b_inp = new BufferedReader(new InputStreamReader(d_inp));
						String line;
						for (;(line = b_inp.readLine()) != null;) {
							//XtalEdit.logArea.setText(XtalEdit.logArea.getText() + "\n<stdout>" + line);
							System.out.println("<stdout>" + line);
						}
						b_inp.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			};
			Runnable errrun = new Runnable() {
				public void run() {
					try {
						InputStream inp = pyps.getErrorStream();
						DataInputStream d_inp = new DataInputStream(inp);
						BufferedReader b_inp = new BufferedReader(new InputStreamReader(d_inp));
						String line;
						for (;(line = b_inp.readLine()) != null;) {
//							XtalEdit.logArea.setText(XtalEdit.logArea.getText() + "\n<stderr>" + line);
							System.out.println("<stderr>" + line);
						}
						b_inp.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			};

			Thread thread = new Thread(stdrun);
			Thread thread2 = new Thread(errrun);

			thread.start();
			thread2.start();

			try {
				thread.join();
				thread2.join();
				pyps.waitFor();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

		}

	}
}