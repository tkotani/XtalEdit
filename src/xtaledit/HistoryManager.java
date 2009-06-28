package xtaledit;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.util.StringTokenizer;

import javax.swing.DefaultListModel;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JScrollPane;
import javax.swing.ListCellRenderer;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

/*
 * Created on 2003/08/29
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
public class HistoryManager extends JFrame implements ListSelectionListener, ActionListener {

    private XtalEdit frame = null;
    private JMenuBar jmb = null;

    private JLabel descri = null;
    private JList list = null;
    private HistoryCellRenderer render = null;
    private DefaultListModel listmodel= null;

    public JMenu histmenu = null;
    public JMenuItem histmi = null;

    public HistoryManager(XtalEdit frame, JMenuBar jmb) {
        this.frame = frame;
        this.jmb = jmb;
		

        setTitle("History");
        setBounds(10, 10, 200, 200);

        descri = new JLabel("");
        descri.setHorizontalAlignment(JLabel.CENTER);

        list = new JList();
        listmodel = new DefaultListModel();
        list.setModel(listmodel);
        listmodel.addElement("No Log");
        
        list.addListSelectionListener(this);

        // CellRenderer
        render = new HistoryCellRenderer();
        list.setCellRenderer(render);

        JScrollPane scrollPane = new JScrollPane();
        scrollPane.getViewport().setView(list);
        scrollPane.setSize(new Dimension(200, 150));
 
        getContentPane().add(scrollPane, BorderLayout.CENTER);
        getContentPane().add(descri, BorderLayout.SOUTH);

        // Closing processing
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent we) {
                setVisible(false);
            }
        });

    }
    public void addHistory(int lognum,String filepath) {
        int num = (int)(lognum*2);
        if(lognum==0){
            listmodel.removeAllElements();
        }
        File moduleF = new File(filepath);
        String moduleDir = moduleF.getParentFile().getName();
        String modulename = moduleF.getName();
        
        String input = String.valueOf(lognum)+"i--" + moduleDir + "--" + modulename;
        String output = String.valueOf(lognum)+"o--" + moduleDir + "--" + modulename;
        
        String errortext = null;
        String error = XtalEdit.LogDir+"Error_output"+lognum+".log";
        File errorFile = new File(error);
        if(errorFile != null && errorFile.exists()){
            errortext = frame.readFile(errorFile);
        }
        if(errortext.length()>0){
            input = "Error "+input;
            output = "Error "+output;
            listmodel.addElement(input);
            listmodel.addElement(output);
        }else{
            listmodel.addElement(input);
            listmodel.addElement(output);
        }

        
        descri.setText("Log Num" + String.valueOf(frame.logFileMax));
        
    }

    public void actionPerformed(ActionEvent e) {
        setVisible(true);
    }

    public void valueChanged(ListSelectionEvent e) {
        if (e.getValueIsAdjusting()) {
            return;
        }

        JList theList = (JList)e.getSource();

        if (theList.isSelectionEmpty()) {
            descri.setText("");
        } else if(theList.getSelectedValue().equals("No Log")){
            ;
        }
        else {
            String str = (String)list.getSelectedValue();
            RecoverLog(str);
        }
    }
    private void RecoverLog(String selectstr){
    	
    	if(selectstr.startsWith("Error") ){
    		selectstr = selectstr.replaceAll("Error","");
    	}
    	
        StringTokenizer stoken = new StringTokenizer(selectstr,"-");
        String lognum = stoken.nextToken();
        
        lognum = lognum.trim();
        String type = lognum.substring(lognum.length()-1,lognum.length());
        lognum = lognum.substring(0,lognum.length()-1);
        
        String editfilename = "";
        String logfilename = "";
        String edittext = "";
        String logtext = "";
        if(type.equals("i")){
            editfilename = XtalEdit.LogDir+"EditWindow_input"+lognum+".log";
            edittext = frame.readFile(new File(editfilename));
            System.out.println(edittext);
            logtext = "";
            frame.editArea.setText(edittext);
            frame.logArea.setText(logtext);
        }else if(type.equals("o")){
            editfilename = XtalEdit.LogDir+"EditWindow_output"+lognum+".log";
            edittext = frame.readFile(new File(editfilename));
            logfilename = XtalEdit.LogDir+"ResultWindow_output"+lognum+".log";
            logtext = frame.readFile(new File(logfilename));
            frame.editArea.setText(edittext);
            frame.logArea.setText(logtext);
        }
        
    }
    class HistoryCellRenderer extends JLabel implements ListCellRenderer {
        public HistoryCellRenderer(){
            setOpaque(true);
        }

        public Component getListCellRendererComponent(JList list, Object value, int index,
            boolean isSelected, boolean cellHasFocus){

            setText(value.toString());

            if (cellHasFocus){
                setBackground(Color.blue);
                setForeground(Color.white);

                setHorizontalAlignment(JLabel.CENTER);
            }else{
                setBackground(Color.white);
                setForeground(Color.black);
                setHorizontalAlignment(JLabel.LEFT);
            }

            if(value.toString().indexOf("Error")!=-1){
                setForeground(Color.red);
            }

            return this;
        }
    }




}
