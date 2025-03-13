       IDENTIFICATION DIVISION.
       PROGRAM-ID. handler.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       LINKAGE SECTION.
       01  OUTPUT-STRING            PIC X(100).
       01  INPUT-STRING             PIC X(40).

       PROCEDURE DIVISION USING INPUT-STRING OUTPUT-STRING.

      * Construct greeting message
           STRING 'Hello ' INPUT-STRING DELIMITED BY X'00' '!'
               INTO OUTPUT-STRING
           GOBACK.

       END PROGRAM handler.
