package cn.wch.ch9140uart.task;

import java.io.File;



public class FileTaskBean {

    private File file;

    public FileTaskBean( File file) {

        this.file = file;
    }


    public File getFile() {
        return file;
    }
}
