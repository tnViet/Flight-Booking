package com.flightbooking.model;

public class Aircraft {
    private int id;
    private String modelName;
    private int totalRows;
    private int columnsPerRow;
    private String columnNames; // Comma separated: A,B,C,D

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public int getTotalRows() {
        return totalRows;
    }

    public void setTotalRows(int totalRows) {
        this.totalRows = totalRows;
    }

    public int getColumnsPerRow() {
        return columnsPerRow;
    }

    public void setColumnsPerRow(int columnsPerRow) {
        this.columnsPerRow = columnsPerRow;
    }

    public String getColumnNames() {
        return columnNames;
    }

    public void setColumnNames(String columnNames) {
        this.columnNames = columnNames;
    }

    public String[] getColumnList() {
        return columnNames != null ? columnNames.split(",") : new String[0];
    }
}
