package cn.wch.ch9140uart.storage;

import java.io.File;

/**
 * 保存接收状态
 */
public class SaveBean {
    private SaveType type=SaveType.SHOW_SCREEN;
    private File file;

    public SaveBean(SaveType type, File file) {
        this.type = type;
        this.file = file;
    }

    public SaveBean(SaveType type) {
        this.type = type;
    }

    public SaveType getType() {
        return type;
    }

    public void setType(SaveType type) {
        this.type = type;
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }
}
