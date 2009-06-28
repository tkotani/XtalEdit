 
package xtaledit;
import java.awt.Color;
import java.util.StringTokenizer;

import javax.swing.JTextArea;
import javax.swing.text.BadLocationException;
import javax.swing.text.DefaultHighlighter;
import javax.swing.text.Highlighter;
import javax.swing.text.JTextComponent;

/*
 * Created on 2003/06/23
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
public class PythonHandler {

    private Color HighlightCol = new Color(0, 153, 153);
    private Object hlopyt;
    private Object hlomsg;

    private JTextArea editArea;
    private JTextArea logArea;
    

    public PythonHandler(JTextArea editArea, JTextArea logArea) {
        this.editArea = editArea;
        this.logArea = logArea;
    }
    public void JumpToError() {
        
        
        int line = getCurrentLineNumber(logArea);
        String str = getLineContents(logArea, line);
            
        int errline = getErrorLineNum(str);
        if (errline >= 0) {
            int p = logArea.getCaretPosition();
            logArea.select(p, p);

            hlomsg = setLineHighligh(logArea, line, false);
            hlopyt = setLineHighligh(editArea, errline, true);

            if (hlopyt != null) {
                editArea.requestFocus();
                int q = editArea.getCaretPosition();
                editArea.select(q, q);
            }
        }
    }
    public int getCurrentLineNumber(JTextArea logArea) {
        try {
            int p = logArea.getCaretPosition();
            if (p < 0)
                return (-1);

            int line = logArea.getLineOfOffset(p);
            return line;
        } catch (BadLocationException e1) {
            return (-1);
        }
    }
    private int[] getLinePos(JTextArea txt, int line) {
        if (line < 0)
            return (null);

        int pos[] = new int[2];
        try {
            int s = txt.getLineStartOffset(line); // s is before start
            int e = txt.getLineEndOffset(line) - 1; // e is after end

            if (s < 0 || e < 0)
                return (null);
            pos[0] = s;
            pos[1] = e;
        } catch (BadLocationException e1) {
            return (null);
        }
        return (pos);
    }
    private String getLineContents(JTextArea txt, int line) {
        if (line < 0)
            return (null);
        int[] pos = getLinePos(txt, line);
        if (pos == null)
            return (null);
        int s = pos[0];
        int e = pos[1];
        if (s < 0 || e < 0)
            return (null);

        String str = null;
        try {
            str = txt.getText(s, e - s);
        } catch (BadLocationException ex) {
            return (null);
        }
        return (str);
    }
    private Object setLineHighligh(JTextArea txt, int line, boolean sw_car) {
        if (line < 0)
            return (null);
        int[] pos = getLinePos(txt, line);
        if (pos == null)
            return (null);
        int s = pos[0];
        int e = pos[1];
        if (s < 0 || e < 0)
            return (null);

        Object obj = setHighligh(txt, s, e, HighlightCol);
        if (sw_car)
            editArea.moveCaretPosition(e);
        return (obj);
    }
    /*
     *  init Highlighter
     */
    private Highlighter initHighligh(JTextComponent com){
        DefaultHighlighter hl = new DefaultHighlighter();
        com.setHighlighter(hl);
        
        return(hl);
    }
    private Object setHighligh(JTextComponent com, int s, int e, Color col) {
        DefaultHighlighter.DefaultHighlightPainter dhp = new DefaultHighlighter.DefaultHighlightPainter(col);

        Highlighter hl = getHighlight(com);
        Object obj;
        try {
            obj = hl.addHighlight(s, e, dhp);
        } catch (BadLocationException ex) {
            return (null);
        }
        return (obj);
    }
    
    private Highlighter getHighlight(JTextComponent com) {
        Highlighter hl = com.getHighlighter();
        return (hl);
    }
    private int getErrorLineNum(String buf){
        try{
            if(buf==null || buf.length()==0)return(-1);
            
            int num=-1;
            StringTokenizer st = new StringTokenizer(buf," ,");
            while(true){
                String str;
                str = st.nextToken();
                if(str==null || str.length()==0)return(-1);
                
                if(str.equals("line")){
                    str = st.nextToken();
                    if(str==null || str.length()==0)return(-1);
                    
                    if(!Math2.chk_digit(str)){
                        int e = str.length();
                        for(int i=0;i<str.length();i++){
                            char c =str.charAt(i);
                            if(Character.isDigit(c)) continue;
                            e=i-1;
                            break;
                        }
                        if(e<0)return(-1);
                        String str2 = str.substring(0,e+1);
                        num = Math2.s_i(str);
                    }
                    else{
                        num = Math2.s_i(str);
                    }
                    
                    break;
                }
            }
            return(num-1);
        }
        catch(Exception e){
            return(-1);
        }
    }
    public void editMouseClicked(java.awt.event.MouseEvent e){
        removeHighligh(editArea,hlopyt);
        removeHighligh(logArea,hlomsg);
    }
    public void logMouseClicked(java.awt.event.MouseEvent e){
        removeHighligh(editArea,hlopyt);
        removeHighligh(logArea,hlomsg);
    }
    private void removeHighligh(JTextComponent com,Object obj){
        if(obj==null) return;
        try{
            Highlighter hl = getHighlight(com);
            hl.removeHighlight(obj);
            obj = null;
        }catch(Exception ex){
            return;
        }
    }
    public int getColNumber(JTextArea ta,int line){
        int cal = ta.getCaretPosition();
        int offset = 0;
        try {
            offset = ta.getLineStartOffset(line);
        } catch (BadLocationException e) {
            e.printStackTrace();
        }
        return (cal-offset); 
    }
}
