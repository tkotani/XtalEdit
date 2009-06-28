package xtaledit;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import javax.swing.JTextArea;

/*
 * Created on 2003/07/31
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
public class ExecutePython {

    private JTextArea editArea = null;
    private JTextArea logArea = null;
    private Process pyps = null;
    private String moduleName = null;
    private XtalEdit frame = null;

    String errorMsg = "";

    public ExecutePython() {
    }

    public ExecutePython(XtalEdit frame, String moduleName) {
        this.editArea = frame.editArea;
        this.logArea = frame.logArea;
        this.frame = frame;

        frame.removeFiles();
        File csyfile = new File(XtalEdit.CsyFilePath);
        String text = editArea.getText().replaceAll("\r\n", "\n");
        frame.writeFile(text, csyfile);
    }

    public boolean Execute(String filepath,String arg) {

        frame.createPreLogFile(moduleName);
        
        errorMsg = "";
        // Execution
        File pythonfile = new File(filepath);

        if (pythonfile.exists()) {
            Runtime runtime = Runtime.getRuntime();
            
            String[] execCommand;
            if(arg==null){
                execCommand = new String[2];
                execCommand[0] = "python";
                execCommand[1] = filepath;
            }else{
                execCommand = new String[3];
                execCommand[0] = "python";
                execCommand[1] = filepath;
                execCommand[2] = arg;
            }

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
                        String line = null; 
                        for (;(line = b_inp.readLine()) != null;) {
                            errorMsg = errorMsg + line+"\n";
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
                File listF = null;
                String listName = "";
                File resultDir = new File("./result");
                boolean fileFlag1 = false;
                boolean fileFlag2 = false;
                while (fileFlag1 & fileFlag2) {
                    for (int i = 0; i < (resultDir.listFiles()).length; i++) {
                        listF = (resultDir.listFiles())[i];
                        listName = listF.getName();
                        if (listName.equals("EditWindow.dat")) {
                            fileFlag1 = true;
                        } else if (listName.equals("ResultWindow.dat")) {
                            fileFlag2 = true;
                        }
                    }
                }
                pyps.waitFor();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }else{
            frame.logArea.setText("\n"+pythonfile.getName()+" does not exist\n");
        }

        if(errorMsg.length()>0)
            return false;
        else
            return true;

    }
    public void showResult(boolean flag,String filepath) {
        
        if(flag){
            File listF = null;
            String listName = "";
            File resultDir = new File("./result");
            for (int i = 0; i < (resultDir.listFiles()).length; i++) {
                listF = (resultDir.listFiles())[i];
                listName = listF.getName();
                if (listName.equals("EditWindow.dat")) {
                    String result = frame.readFile(listF);
                    editArea.setText(result);

                } else if (listName.equals("ResultWindow.dat")) {
                    String result = frame.readFile(listF);
                    logArea.setText(result);

                } else {
                    //logArea.setText(logArea.getText() + "Error : " + listF.getName() + " inproper file name\n");
                }
            }
        }else{
            logArea.setText(frame.changeErrorLine(errorMsg));
        }
        
        frame.createPostLogFile(filepath,errorMsg);

    }

}
