package xtaledit;
import java.awt.Color;
import java.awt.Container;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

/*
 * Created on 2003/07/30
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
public class HelpManager extends JFrame {

    private Container container = null;
    public static JTextArea helpTextArea = null; 
    
    public HelpManager(){
       
       // Set Title
        super("Help");
        container = this.getContentPane();
        
        // Closing processing
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent we) {
                setVisible(false);
            }
        });
        
        // TextArea
        helpTextArea = new JTextArea(10, 80);
        helpTextArea.setTabSize(4);
        helpTextArea.setBackground(Color.white);

        // Scroll
        JScrollPane helpComp =
            new JScrollPane(
                helpTextArea,
                JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
                JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        container.add(helpComp);
         
    }
    public void show(String helppath){
        
        setBounds(20, 50, 400, 350);
        setVisible(true);

        File helpfile = new File(helppath);
        helpTextArea.setText(readFile(helpfile));
        requestFocus();
    }

    public String readFile(File FILE) {
        StringBuffer sb = new StringBuffer();
        try {
            FileReader fr = new FileReader(FILE);
            char[] buffer = new char[1];
            while (fr.read(buffer) > -1)
                sb.append(buffer);
            fr.close();
        } catch (FileNotFoundException error) {
            helpTextArea.setText("Error : File " + FILE.getName() + " Not Found\n");
        } catch (IOException error) {
            helpTextArea.setText("Error : File " + FILE.getName() + " IO Error\n");
        } catch (Exception error) {
            helpTextArea.setText("Error : File " + FILE.getName() + " Error\n");
        }
        return sb.toString();
    }
}
