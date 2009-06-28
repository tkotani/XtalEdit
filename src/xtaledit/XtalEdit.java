
/*
 * Created on 2003/06/11
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

package xtaledit;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.swing.*;
import javax.swing.border.BevelBorder;
import javax.swing.border.TitledBorder;
import javax.swing.event.CaretEvent;
import javax.swing.event.CaretListener;

import xtaledit.ui_user_module.*;

public class XtalEdit extends JFrame {

    // System
    public static final String XtalEditHome = System.getProperty("user.dir");
    public static final String fileSeparateChar = System.getProperty("file.separator");
    public static final String osName = System.getProperty("os.name"); //r-goto 2003.7.4
    public static Font font = new Font("Courier New", Font.PLAIN, 14);

    // Directroy
    public static final String UserModuleDir =
        XtalEditHome + fileSeparateChar + "UserModule" + fileSeparateChar;
    public static final String LogDir = XtalEditHome + fileSeparateChar + "log" + fileSeparateChar;
    public static final String ResultDir = XtalEditHome + fileSeparateChar + "result" + fileSeparateChar;
    public static final String TempDir = XtalEditHome + fileSeparateChar + "temp" + fileSeparateChar;
    public static final String SampleDir = XtalEditHome + fileSeparateChar + "samples";
    public static final String runpytonDir = UserModuleDir + fileSeparateChar + "runPython";

    // Bound
    private static double divH = 0.5;
    private static double divV = 0.5;

    // File
    public static final String CsyFilePath = TempDir + "xxx.csy1";

    // XtalEdit Frame Object
    public XtalEdit frame = null;
    Container container;

    // ToolBars
    public JToolBar edittool = null;
    public JToolBar logtool = null;
    public JToolBar buttonToolBar = null;

    // Text Area
    public JTextArea editArea = null;
    public JTextArea logArea = null;
    private TitledBorder editborder = null;
    private JPanel editPanel1 = null;
    private JSplitPane splitPane1 = null;
    boolean continuousLayout = false;
    public TitledBorder titleborder = null;
    public int line;
    public int column;

    // CurrentFile object
    public File currentFile = null;
    private ExtensionFilter[] fileFilters = null;

    // EditWindow_input.1 Module_input.1
    // EditWindow_output.1,ResultWindow_output.1,Error_output.1
    public int logFileNum = -1;
    public int logFileMax = -1;
    public boolean redoMax = false;
    public static final int MAX_LOGNUM = 2048;
    private File[] EditWindow_input = null;
    private String[] Module_input = null;
    private File[] EditWindow_output = null;
    private File[] ResultWindow_output = null;
    private File[] Error_output = null;

    public HistoryManager hist = null;

    // FileDialog
    JFileChooser FC = null;

    // Title Bar Name
    public static String titlename = "";

    // Process
    private Process pyps = null;

    // User UI Configuration
    private Properties toolbarProp = null;
    private static final String toolbarConf = "./toolbar.conf";
    private File toolbarConfFile = null;

    // Python Handler
    public PythonHandler pyhandler = null;
    // Help Manager
    public HelpManager helpObj = null;
    // Module Manager
    public ModuleManager molobj = null;
    
    // ActionListener
    public ActionListener fontlistener = null;
    public ActionListener viewlistener = null;
    public JCheckBoxMenuItem editiconMenu = null;
    public JCheckBoxMenuItem logiconMenu = null;
    public JCheckBoxMenuItem buttonMenu = null;
    public JCheckBoxMenuItem division = null;

    // Rasmol check
    public String rasmolApplication = null;
    RasmolCheck ras = null; // r-goto 2003.7.4

    public static void main(String[] args) {

        XtalEdit frame = null;
        frame = new XtalEdit();
        frame.SetUI(frame);

    }
    private XtalEdit() {

        // Toolbar Configuration
        toolbarConfFile = new File(toolbarConf);
        toolbarProp = new Properties();

        currentFile = new File(XtalEditHome);
        container = this.getContentPane();

        // Closing processing
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent we) {
                Font font = editArea.getFont();
                toolbarProp.setProperty("Font",font.getName());
                toolbarProp.setProperty("Attribute",String.valueOf(font.getStyle()));
                toolbarProp.setProperty("Size",String.valueOf(font.getSize()));
                
                
                FileOutputStream fos = null;
                try {
                    fos = new FileOutputStream(toolbarConfFile);
                    toolbarProp.store(fos, "Configuration");
                    fos.close();
                } catch (FileNotFoundException e1) {
                    e1.printStackTrace();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }   
                
                System.exit(0);
            }
        });

        // Initialize
        removeFiles();
        deleteAllFiles(LogDir);

        // FileFilter
        fileFilters =
            new ExtensionFilter[] {
                new ExtensionFilter("Csy File", new String[] { ".csy" }),
                new ExtensionFilter("Csy1 File", new String[] { ".csy1" }),
                };

        // Undo , Redo
        EditWindow_input = new File[MAX_LOGNUM];
        Module_input = new String[MAX_LOGNUM];
        EditWindow_output = new File[MAX_LOGNUM];
        ResultWindow_output = new File[MAX_LOGNUM];
        Error_output = new File[MAX_LOGNUM];

        // Rasmol check
        ras = new RasmolCheck(); // 2003.7.14 r-goto
        rasmolApplication = ras.rasmolApplication;

    }

    // Warning Dialog
    public JFrame toplevel;
    public JDialog dialog;
    public JLabel dialogMessage;
    public JButton dialogOk, dialogCancel;

    private JPopupMenu editpopmenu;
    private JPopupMenu logpopmenu;

    /*
     * GUI
     */

    public void SetUI(XtalEdit frame) {

        this.frame = frame;
        JPanel MainPanel = new JPanel(new BorderLayout());

        // File Dialog
        FC = new JFileChooser();
        FC.setCurrentDirectory(new File(SampleDir));
        for (int i = 0; i < fileFilters.length; i++) {
            FC.addChoosableFileFilter(fileFilters[i]);
        }



        // create ActionListener
        ActionListener openListener = new OpenCommand();
        ActionListener exitListener = new ExitCommand();
        ActionListener copyListener = new CopyCommand();
        ActionListener cutListener = new CutCommand();
        ActionListener pasteListener = new PasteCommand();
        ActionListener runpythonListener = new RunPYTHONCommand();
        fontlistener = new FontCommand();

        /*
         *  Edit Panel
         */

        // Edit Text Area

        editArea = new JTextArea(10, 80);
        editArea.setTabSize(4);
        editArea.setBackground(Color.white);
        editArea.setFont(font);
        editArea.addCaretListener(new ShowLineCommand());
        ActionListener editclearListener = new TextAreaClearCommand(editArea);

        editPanel1 = new JPanel();
        editPanel1.setLayout(new BorderLayout());

        editborder = new TitledBorder("Edit Window");
        editPanel1.setBorder(editborder);

        edittool = new JToolBar();
        edittool.setOrientation(JToolBar.VERTICAL);

        // iconPanel1
        JPanel iconPanel1 = new JPanel();
        iconPanel1.setLayout(new BoxLayout(iconPanel1, BoxLayout.Y_AXIS));
        JButton editOpen = new JButton(new ImageIcon("./icons/file-open.gif"));
        JButton editSave = new JButton(new ImageIcon("./icons/file-save.gif"));
        JButton editSaveAs = new JButton(new ImageIcon("./icons/file-saveAs.gif"));
        editOpen.addActionListener(openListener);
        editSave.addActionListener(new SaveCommand(editArea, false));
        editSaveAs.addActionListener(new SaveCommand(editArea, true));
        editOpen.setToolTipText("File Open in Edit Panel");
        editSave.setToolTipText("Save Edit Panel Text");
        editSaveAs.setToolTipText("Save Edit Panel Text As a File");
        iconPanel1.add(editOpen);
        iconPanel1.add(editSave);
        iconPanel1.add(editSaveAs);

        // iconPanel3
        JPanel iconPanel3 = new JPanel();
        iconPanel3.setLayout(new BoxLayout(iconPanel3, BoxLayout.Y_AXIS));
        JButton editPython = new JButton(new ImageIcon("./icons/py.gif"));
        JButton editClear = new JButton(new ImageIcon("./icons/edit-clear.gif"));
        editPython.addActionListener(runpythonListener);
        editClear.addActionListener(editclearListener);
        editPython.setToolTipText("Run Python");
        editClear.setToolTipText("Clear Edit Panel");
        iconPanel3.add(editPython);
        iconPanel3.add(editClear);

        edittool.add(iconPanel1);
        edittool.addSeparator();
        edittool.add(iconPanel3);

        JPanel editPanel1_2 = new JPanel(new BorderLayout());

        // Combine Pane
        editPanel1.add(edittool, BorderLayout.WEST);
        editPanel1.add(editPanel1_2, BorderLayout.CENTER);

        // Scroll
        JScrollPane editComp =
            new JScrollPane(
                editArea,
                JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
                JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        editPanel1_2.add(editComp);

        // Pop up menu
        editpopmenu = new JPopupMenu();

        JMenuItem jmiCopy = new JMenuItem("Copy");
        JMenuItem jmiCut = new JMenuItem("Cut");
        JMenuItem jmiPaste = new JMenuItem("Paste");
        JMenuItem jmeditOpen = new JMenuItem("Open");
        JMenuItem jmeditSave = new JMenuItem("Save");
        JMenuItem jmeditSaveAs = new JMenuItem("SaveAs");
        JMenuItem jmeditClear = new JMenuItem("Clear");

        // ShortCut
        KeyStroke keyst_cut = KeyStroke.getKeyStroke(KeyEvent.VK_X, Event.CTRL_MASK);
        KeyStroke keyst_copy = KeyStroke.getKeyStroke(KeyEvent.VK_C, Event.CTRL_MASK);
        KeyStroke keyst_paste = KeyStroke.getKeyStroke(KeyEvent.VK_V, Event.CTRL_MASK);
        jmiCopy.setAccelerator(keyst_copy);
        jmiCut.setAccelerator(keyst_cut);
        jmiPaste.setAccelerator(keyst_paste);

        jmiCopy.addActionListener(copyListener);
        jmiCut.addActionListener(cutListener);
        jmiPaste.addActionListener(pasteListener);
        jmeditOpen.addActionListener(openListener);
        jmeditSave.addActionListener(new SaveCommand(editArea, false));
        jmeditSaveAs.addActionListener(new SaveCommand(editArea, true));
        jmeditClear.addActionListener(editclearListener);

        editArea.addMouseListener(new EditPressMouse());

        editpopmenu.add(jmeditOpen);
        editpopmenu.add(jmeditSave);
        editpopmenu.add(jmeditSaveAs);
        editpopmenu.add(jmeditClear);

        /*
         *  Log Panel
         */
        JPanel logPanel1 = new JPanel(new BorderLayout());
        logPanel1.setBorder(new TitledBorder("Result Window"));
        // Log window
        logtool = new JToolBar();
        logtool.setOrientation(JToolBar.VERTICAL);
        JPanel logPanel1_2 = new JPanel(new BorderLayout());

        // Log Text Area
        logArea = new JTextArea(10, 80);
        logArea.setTabSize(4);
        logArea.setBackground(Color.white);
        logArea.setEditable(false);
        logArea.setFont(font);

        ActionListener logclearListener = new TextAreaClearCommand(logArea);

        JScrollPane logComp =
            new JScrollPane(
                logArea,
                JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
                JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        logPanel1_2.add(logComp);

        // iconPanel1
        JPanel iconPanel_log = new JPanel();
        iconPanel_log.setLayout(new BoxLayout(iconPanel_log, BoxLayout.Y_AXIS));
        JButton logSave = new JButton(new ImageIcon("./icons/file-saveAs.gif"));
        JButton logClear = new JButton(new ImageIcon("./icons/edit-clear.gif"));
        logSave.addActionListener(new SaveCommand(logArea, false));
        logClear.addActionListener(logclearListener);
        logSave.setToolTipText("Save Log Panel As");
        logClear.setToolTipText("Clear Log Panel");
        iconPanel_log.add(logSave);
        iconPanel_log.add(logClear);
        logtool.add(iconPanel_log);

        // Pop up menu
        logpopmenu = new JPopupMenu();

        JMenuItem jmlogClear = new JMenuItem("Clear");
        jmlogClear.addActionListener(logclearListener);
        logpopmenu.add(jmlogClear);

        logArea.addMouseListener(new LogPressMouse());

        logPanel1.add(logtool, BorderLayout.WEST);
        logPanel1.add(logPanel1_2, BorderLayout.CENTER);

        // Create Menu Bar with BevelBorder
        JMenuBar jmb = new JMenuBar();
        jmb.setBorder(new BevelBorder(BevelBorder.RAISED));
        container.add(jmb, BorderLayout.NORTH);

        /*
         *  Python Handler
         */
        pyhandler = new PythonHandler(editArea, logArea);


        /*
         *  Help
         */
        helpObj = new HelpManager();


        /*
         *  History function
         */

        hist = new HistoryManager(frame, jmb);

        /*
         *  Set Edit and Log field to SplitPane
         */
        splitPane1 = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
        splitPane1.setLeftComponent(editPanel1);
        splitPane1.setRightComponent(logPanel1);
        splitPane1.setContinuousLayout(true);

        MainPanel.add(splitPane1);
        container.add(MainPanel, BorderLayout.CENTER);

        // UserPanel Set up
        editiconMenu = new JCheckBoxMenuItem("Edit Icons", true);
        logiconMenu = new JCheckBoxMenuItem("Result Icons", true);
        buttonMenu = new JCheckBoxMenuItem("Button Panel", true);
        division = new JCheckBoxMenuItem("Divide Vertically", true);

        //Division
        ItemListener divisionlistener = new DivisionListener(division);
        division.addItemListener(divisionlistener);
        //EditWindow icon
        ItemListener editiconlistener = new OptionToolbarListener(edittool, editiconMenu);
        editiconMenu.addItemListener(editiconlistener);
        //ResultWindow icon
        ItemListener logiconlistener = new OptionToolbarListener(logtool, logiconMenu);
        logiconMenu.addItemListener(logiconlistener);

        /*
         *  Module Button
         */
        molobj = new ModuleManager(frame);
        // Menu Manager
        MenuManager menuobj = new MenuManager(frame, molobj.getmoduleArray(), jmb);
        // Button Manager
        ButtonManager bmobj = new ButtonManager(frame, molobj.getmoduleArray(), container);

        buttonToolBar = bmobj.buttonToolBar;

        //Button panel
        ItemListener buttonlistener = new OptionToolbarListener(bmobj.buttonToolBar, buttonMenu);
        buttonMenu.addItemListener(buttonlistener);

        setBounds(20, 50, 800, 700);
        setVisible(true);

        // UserSet Conf
        getCheckBoxFlag(division, editiconMenu, logiconMenu, buttonMenu);
        getUserFont();
        
    }

    /*
    *   ActionListener 
    */
    public class OpenCommand implements ActionListener {
        public void actionPerformed(ActionEvent e) {

            // Show up Open Dialog window
            int returnVal = FC.showOpenDialog(frame);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = FC.getSelectedFile();
                String str = readFile(file);
                editArea.setText(str);
                currentFile = file;
                SetTitleName(file);
            }
            
            if(currentFile!=null && ! currentFile.getName().equals("XtalEdit"))
                editPanel1.setBorder(new TitledBorder("EditWindow  [Line " + line + "  Col " + column + "]"+"  Read From "+currentFile.getName()));
            else
                editPanel1.setBorder(new TitledBorder("EditWindow  [Line " + line + "  Col " + column + "]"));
        }

    }

    public class SaveCommand implements ActionListener {
        JTextArea TA = null;
        boolean flag = false; // false Save true SaveAs
        public SaveCommand(JTextArea TA, boolean flag) {
            this.TA = TA;
            this.flag = flag;
        }
        public void actionPerformed(ActionEvent e) {

            // Save
            if (flag = false) {
                JLabel la = new JLabel("Overwrite ?");
                la.setBorder(new TitledBorder("Save confirmation"));
                Object[] obj = { la };
                int ans =
                    JOptionPane.showConfirmDialog(
                        container,
                        obj,
                        "Confirmation",
                        JOptionPane.OK_CANCEL_OPTION);
                if (ans == 0) {
                    if (currentFile != null && currentFile.getName().length() > 0) {
                        writeFile(TA.getText(), currentFile);
                    } else {
                        logArea.setText("/n current file is not given\n");
                    }
                }
            } else {
                // Save As
                int returnVal = FC.showSaveDialog(frame);

                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    File file = FC.getSelectedFile();
                    writeFile(TA.getText(), file);
                    currentFile = file;
                    SetTitleName(file);
                }

            }
            
            if(currentFile!=null)
                editPanel1.setBorder(new TitledBorder("EditWindow  [Line " + line + "  Col " + column + "]"+"  Read From "+currentFile.getName()));
            else
                editPanel1.setBorder(new TitledBorder("EditWindow  [Line " + line + "  Col " + column + "]"));

        }
    }

    public class ExitCommand implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            frame.getWindowListeners()[0].windowClosing(new WindowEvent(frame,WindowEvent.WINDOW_CLOSING));
        }
    }
    public class TextAreaClearCommand implements ActionListener {
        JTextArea TA = null;
        public TextAreaClearCommand(JTextArea TA) {
            this.TA = TA;
        }
        public void actionPerformed(ActionEvent e) {
            TA.setText("");
        }
    }

    public class CopyCommand implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            editArea.copy();
        }
    }
    public class CutCommand implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            editArea.cut();
        }
    }

    public class PasteCommand implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            editArea.paste();
        }
    }
    public class OptionToolbarListener implements ItemListener {
        JToolBar bar = null;
        JCheckBoxMenuItem cbm = null;
        OptionToolbarListener(JToolBar bar, JCheckBoxMenuItem cbm) {
            this.cbm = cbm;
            this.bar = bar;
        }
        public void itemStateChanged(ItemEvent e) {
            if (!cbm.getState()) {
                bar.setVisible(false);
                toolbarProp.setProperty(cbm.getText(), "FALSE");
            } else {
                bar.setVisible(true);
                toolbarProp.setProperty(cbm.getText(), "TRUE");
            }
            FileOutputStream fos = null;
            try {
                fos = new FileOutputStream(toolbarConfFile);
                toolbarProp.store(fos, "CheckBoxMenuItem Configuration");
                fos.close();
            } catch (FileNotFoundException e1) {
                e1.printStackTrace();
            } catch (IOException e1) {
                e1.printStackTrace();
            }

        }
    }
    public class DivisionListener implements ItemListener {

        JCheckBoxMenuItem cbm = null;
        DivisionListener(JCheckBoxMenuItem cbm) {
            this.cbm = cbm;
        }
        public void itemStateChanged(ItemEvent e) {

            if (!cbm.getState()) {
                splitPane1.setOrientation(JSplitPane.HORIZONTAL_SPLIT);
                toolbarProp.setProperty(cbm.getText(), "FALSE");
                splitPane1.setDividerLocation(XtalEdit.divH);
            } else {
                splitPane1.setOrientation(JSplitPane.VERTICAL_SPLIT);
                toolbarProp.setProperty(cbm.getText(), "TRUE");
                splitPane1.setDividerLocation(XtalEdit.divV);
            }
            FileOutputStream fos = null;
            try {
                fos = new FileOutputStream(toolbarConfFile);
                toolbarProp.store(fos, "CheckBoxMenuItem Configuration");
                fos.close();
            } catch (FileNotFoundException e1) {
                e1.printStackTrace();
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }

    }
    public class RunPYTHONCommand implements ActionListener {
        Process pyps;
        public void actionPerformed(ActionEvent e) {

            try {
                frame.removeFiles();
                File csyfile = new File(XtalEdit.CsyFilePath);
                String text = editArea.getText().replaceAll("\r\n", "\n");
                frame.writeFile(text, csyfile);

                Runtime runtime = Runtime.getRuntime();
                String[] execCommand = new String[2];
                execCommand[0] = "python";
                execCommand[1] = "UserModule/RunPython/RunPython.py";

                logArea.setText("===== RunPython =====\n");
                pyps = runtime.exec(execCommand);

                // •W€o—Í‹z‚¤
                Runnable stdrun = new Runnable() {
                    public void run() {
                        try {
                            InputStream inp = pyps.getInputStream();
                            DataInputStream d_inp = new DataInputStream(inp);
							BufferedReader b_inp = new BufferedReader(new InputStreamReader(d_inp));
                            String line;
                            for (;(line = b_inp.readLine()) != null;) {
                                logArea.setText(logArea.getText() + "\n" + line);
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
                                line = changeErrorLine(line);
                                logArea.setText(logArea.getText() + line);
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

                pyps.waitFor();

            } catch (IOException e1) {
                e1.printStackTrace();
            } catch (InterruptedException e1) {
                e1.printStackTrace();
            }

        }
    }

    private class EditPressMouse implements MouseListener {
        public void mousePressed(MouseEvent e) {
            if (e.isPopupTrigger()) {
                editpopmenu.show(e.getComponent(), e.getX(), e.getY());
            }
        }
        public void mouseReleased(MouseEvent e) {
            if (e.isPopupTrigger()) {
                editpopmenu.show(e.getComponent(), e.getX(), e.getY());
            }
        }
        public void mouseClicked(MouseEvent e) {
            pyhandler.editMouseClicked(e);
        }
        public void mouseEntered(MouseEvent e) {
        }
        public void mouseExited(MouseEvent e) {
        }
        public void mouseMoved(MouseEvent e) {
        }
        public void mouseDragged(MouseEvent e) {
        }
    }
    private class LogPressMouse implements MouseListener {
        public void mousePressed(MouseEvent e) {
            if (e.isPopupTrigger()) {
                logpopmenu.show(e.getComponent(), e.getX(), e.getY());
            }
        }
        public void mouseReleased(MouseEvent e) {
            if (e.isPopupTrigger()) {
                logpopmenu.show(e.getComponent(), e.getX(), e.getY());
            }
        }
        public void mouseClicked(MouseEvent e) {
            int click = e.getClickCount();
            if (click == 1) {
                pyhandler.logMouseClicked(e);
            }
            if (click == 2) {
                pyhandler.JumpToError();
            }
        }
        public void mouseEntered(MouseEvent e) {
        }
        public void mouseExited(MouseEvent e) {
        }
        public void mouseMoved(MouseEvent e) {
        }
        public void mouseDragged(MouseEvent e) {
        }
    }
    public void removeFiles() {

        deleteAllFiles(ResultDir);
        deleteAllFiles(TempDir);

    }

    public class UndoCommand implements ActionListener {
        public void actionPerformed(ActionEvent e) {

			redoMax = false;
			if (logFileNum != -1){
				logFileNum--;
			}
            String previousEditWindow = null;

            if (logFileNum >= 0) {
                previousEditWindow = readFile(EditWindow_input[logFileNum]);
                editArea.setText(previousEditWindow);
                logArea.setText("\ncall logFile No. " + logFileNum);
            } else {
                logArea.setText("\nCan not go backward anymore\n");
            }
        }

    }
    public class RedoCommand implements ActionListener {
        public void actionPerformed(ActionEvent e) {

			if (!redoMax){
				logFileNum++;
			}
            	
            String previousEditWindow = null;

            if (EditWindow_input[logFileNum] != null && EditWindow_input[logFileNum].exists()) {
                previousEditWindow = readFile(EditWindow_input[logFileNum]);
                editArea.setText(previousEditWindow);
                logArea.setText("\ncall logFile No. " + logFileNum);
            } else {
                logArea.setText("\nCan not go forward anymore\n");
                redoMax = true;
            }
        }
    }
    public class ViewCommand implements ActionListener {
        String path = null;
        public ViewCommand(String path){
            this.path = path;
        }
        public void actionPerformed(ActionEvent e){
            helpObj.show(path);
        }
    }
    public class ShowLineCommand implements CaretListener {

        ShowLineCommand() {
        }

        public void caretUpdate(CaretEvent ce) {
            line = pyhandler.getCurrentLineNumber(editArea);
            column = pyhandler.getColNumber(editArea, line);
            if(currentFile!=null)
                editPanel1.setBorder(new TitledBorder("EditWindow  [Line " + line + "  Col " + column + "]"+"  Read From "+currentFile.getName()));
            else
                editPanel1.setBorder(new TitledBorder("EditWindow  [Line " + line + "  Col " + column + "]"));
        }
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
            logArea.setText(logArea.getText() + "\nError : File " + FILE.getName() + " Not Found\n");
        } catch (IOException error) {
            logArea.setText(logArea.getText() + "\nError : File " + FILE.getName() + " IO Error\n");
        } catch (Exception error) {
            logArea.setText(logArea.getText() + error.getStackTrace());
        }

        String str = sb.toString();
        str = str.replaceAll("\r\n", "\n");

        return str;
    }
    public void writeFile(String str, File saveFile) {
        try {
            FileWriter fw = new FileWriter(saveFile);
            fw.write(str);
            fw.flush();
            fw.close();
        } catch (IOException error) {
            System.out.println(error);
        }
    }
    public String changeErrorLine(String line) {

        StringTokenizer stoken = new StringTokenizer(line, "\n");
        String output = "";
        int i = 0;
        while (stoken.hasMoreTokens()) {

            String str = stoken.nextToken();
            str = str.trim();

            if (str.indexOf("<string>") == -1 && str.indexOf("in ?") == -1) {
                output = output + str + "\n";
            } else if (str.indexOf("<string>") != -1 && str.indexOf("in ?") != -1) {
                String str2 = "";
                String chline1 = "";
                StringTokenizer stoken2 = new StringTokenizer(str, ",");
                str2 = stoken2.nextToken();
                str2 = stoken2.nextToken();
                if (str2.indexOf("line") != -1) {
                    chline1 = str2.substring(5, str2.length());
                    chline1 = chline1.trim();
                    int chline2 = Integer.parseInt(chline1) - 9;

                    output = output + " File \"<string>\" line " + chline2 + " in your csy File\n";
                }
            } else {
                output = output + str + "\n";
            }

        }

        return output;
    }
    public void createPreLogFile(String module) {

		logFileMax++;
		logFileNum = logFileMax;
		
        String lognumStr = String.valueOf(logFileMax);

        EditWindow_input[logFileMax] = new File(LogDir + "EditWindow_input" + lognumStr + ".log");
        writeFile(editArea.getText(), EditWindow_input[logFileMax]);
        Module_input[logFileMax] = module;
    }
    public void createPostLogFile(String filepath, String errorstr) {
        String lognumStr = String.valueOf(logFileMax);

        EditWindow_output[logFileMax] = new File(LogDir + "EditWindow_output" + lognumStr + ".log");
        ResultWindow_output[logFileMax] = new File(LogDir + "ResultWindow_output" + lognumStr + ".log");
        Error_output[logFileMax] = new File(LogDir + "Error_output" + lognumStr + ".log");

        writeFile(editArea.getText(), EditWindow_output[logFileMax]);
        writeFile(logArea.getText(), ResultWindow_output[logFileMax]);
        writeFile(errorstr, Error_output[logFileMax]);

        hist.addHistory(logFileMax, filepath);
		
    }

    // RasmolCheck

    // r-goto 2003.6.30 starts
    public File getFILE() {
        return currentFile;
    }

    // 2003.7.29 r-goto
    class FontCommand implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Frame frame = new Frame();
            plotFont(frame);
        }
    }

    private void getCheckBoxFlag(
        JCheckBoxMenuItem div,
        JCheckBoxMenuItem edit,
        JCheckBoxMenuItem log,
        JCheckBoxMenuItem button) {
        if (toolbarConfFile.exists()) {
            try {
                FileInputStream fis = new FileInputStream(toolbarConfFile);
                toolbarProp.load(fis);
                if (toolbarProp.getProperty("Divide Vertically") == null) {
                    splitPane1.setOrientation(JSplitPane.VERTICAL_SPLIT);
                    splitPane1.setDividerLocation(XtalEdit.divV);
                } else if (toolbarProp.getProperty("Divide Vertically").equals("FALSE")) {
                    div.setState(false);
                    splitPane1.setOrientation(JSplitPane.HORIZONTAL_SPLIT);
                    splitPane1.setDividerLocation(XtalEdit.divH);
                } else {
                    splitPane1.setOrientation(JSplitPane.VERTICAL_SPLIT);
                    splitPane1.setDividerLocation(XtalEdit.divV);
                }
                if (toolbarProp.getProperty("Edit Icons") == null) {
                    edit.setState(true);
                } else if (toolbarProp.getProperty("Edit Icons").equals("FALSE")) {
                    edit.setState(false);
                    edittool.setVisible(false);
                } else {
                    edit.setState(true);
                }
                if (toolbarProp.getProperty("Result Icons") == null) {
                    log.setState(true);
                } else if (toolbarProp.getProperty("Result Icons").equals("FALSE")) {
                    log.setState(false);
                    logtool.setVisible(false);
                } else {
                    log.setState(true);
                }
                if (toolbarProp.getProperty("Button Panel") == null) {
                    button.setState(true);
                } else if (toolbarProp.getProperty("Button Panel").equals("FALSE")) {
                    button.setState(false);
                    buttonToolBar.setVisible(false);
                } else {
                    button.setState(true);
                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }
    // 2003.7.30 r-goto
    /**
     * chage fonts in 'editArea' and 'logArea' 
     * @param frame
     */
    protected void plotFont(Frame frame) {
        Font newfon = FontChooserUI.showDialog(frame, null);
        if (newfon != null) {
            editArea.setFont(newfon);
            logArea.setFont(newfon);
        }
    }
    private void deleteAllFiles(String dirpath) {
        File listF = null;
        ArrayList fileList = new ArrayList();
        File tempDir = new File(dirpath);
        try {
            for (int i = 0; i < (tempDir.listFiles()).length; i++) {
                fileList.add((tempDir.listFiles())[i]);
            }

            Iterator it = fileList.iterator();

            while (it.hasNext()) {
                File tmpFile = (File)it.next();
                if (!tmpFile.getName().equals("dummy"))
                    tmpFile.delete();
            }
        } catch (NullPointerException e) {
            ;
        }

    }
    void SetTitleName(File titlefile) {
        File pfile = titlefile.getParentFile();
        String dir = pfile.getAbsolutePath();
        String file = titlefile.getName();
        if (file.equals("XtalEdit")) {
            setTitle(XtalEdit.titlename + " [CurrentDir] " + dir);
        }else{
            setTitle(XtalEdit.titlename + " [CurrentDir] " + dir);
        }
    }
    public void SetTitleName() {
        String dir = currentFile.getAbsolutePath();
        setTitle(XtalEdit.titlename + " [CurrentDir] " + dir);
    }

    public class ExtensionFilter extends javax.swing.filechooser.FileFilter {
        String decs = "";
        String[] extensions = null;
        public ExtensionFilter(String decs, String[] extensions) {
            this.decs = decs;
            this.extensions = (String[])extensions.clone();
        }
        public boolean accept(File f) {
            if (f.isDirectory() == true) {
                return true;
            }
            String name = f.getName();
            int length = name.length();

            for (int i = 0; i < extensions.length; i++) {
                String ext = extensions[i];

                if (name.endsWith(ext) && name.charAt(length - ext.length()) == '.') {
                    return true;
                }
            }
            return false;
        }
        public String getDescription() {
            return decs;
        }

    }
    private void getUserFont(){
        FileInputStream fis;
        try {
            fis = new FileInputStream(toolbarConfFile);
            toolbarProp.load(fis);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        String fontname = toolbarProp.getProperty("Font");
        int attribute = 10;
        int size = 0;
        if(toolbarProp.getProperty("Attribute")!=null)
            attribute = Integer.parseInt(toolbarProp.getProperty("Attribute"));
        if(toolbarProp.getProperty("Size")!=null)
            size = Integer.parseInt(toolbarProp.getProperty("Size"));
        
        if ( font != null && attribute != 10 && size != 0) {
            Font font = new Font(fontname,attribute, size);
            editArea.setFont(font);
            logArea.setFont(font);
        }
        
    }

}
