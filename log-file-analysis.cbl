IDENTIFICATION DIVISION.
       PROGRAM-ID. LogFileAnalysis.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT LOG-FILE ASSIGN TO 'logfile.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  LOG-FILE.
       01  LOG-RECORD.
           05  LOG-LINE PIC X(256).

       WORKING-STORAGE SECTION.
       01  IP-COUNTS.
           05  IP-ENTRY OCCURS 1000 TIMES.
               10  IP-ADDRESS PIC X(15).
               10  IP-COUNT   PIC 9(5) VALUE 0.

       01  STATUS-CODES.
           05  STATUS-ENTRY OCCURS 100 TIMES.
               10  STATUS-CODE PIC X(3).
               10  STATUS-COUNT PIC 9(5) VALUE 0.

       01  TOTAL-REQUESTS PIC 9(9) VALUE 0.
       01  LINE-END PIC X VALUE LOW-VALUE.
       01  WS-INDEX PIC 9(4) VALUE 1.
       01  WS-STATUS-INDEX PIC 9(4) VALUE 1.
       01  WS-IP-INDEX PIC 9(4) VALUE 1.
       01  WS-FOUND PIC X VALUE 'N'.
       01  WS-LOG-DATA.
           05  WS-IP PIC X(15).
           05  FILLER PIC X(1).
           05  WS-TIMESTAMP PIC X(30).
           05  FILLER PIC X(1).
           05  WS-METHOD PIC X(4).
           05  FILLER PIC X(1).
           05  WS-URL PIC X(50).
           05  FILLER PIC X(1).
           05  WS-PROTOCOL PIC X(10).
           05  FILLER PIC X(1).
           05  WS-STATUS PIC X(3).
           05  FILLER PIC X(1).
           05  WS-SIZE PIC X(10).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           OPEN INPUT LOG-FILE
           PERFORM UNTIL LINE-END = HIGH-VALUE
               READ LOG-FILE INTO LOG-LINE
                   AT END MOVE HIGH-VALUE TO LINE-END
                   NOT AT END
                       PERFORM PARSE-LOG-LINE
                       PERFORM UPDATE-COUNTS
               END-READ
           END-PERFORM
           CLOSE LOG-FILE
           PERFORM GENERATE-REPORT
           STOP RUN.

       PARSE-LOG-LINE.
           UNSTRING LOG-LINE DELIMITED BY SPACE
               INTO WS-IP FILLER WS-TIMESTAMP FILLER
               WS-METHOD FILLER WS-URL FILLER
               WS-PROTOCOL FILLER WS-STATUS FILLER
               WS-SIZE.

       UPDATE-COUNTS.
           ADD 1 TO TOTAL-REQUESTS
           PERFORM CHECK-IP-COUNTS
           PERFORM CHECK-STATUS-COUNTS.

       CHECK-IP-COUNTS.
           MOVE 'N' TO WS-FOUND
           PERFORM VARYING WS-IP-INDEX FROM 1 BY 1 UNTIL WS-IP-INDEX > 1000
               IF IP-ADDRESS(WS-IP-INDEX) = WS-IP
                   ADD 1 TO IP-COUNT(WS-IP-INDEX)
                   MOVE 'Y' TO WS-FOUND
                   EXIT PERFORM
               END-IF
           END-PERFORM
           IF WS-FOUND = 'N'
               MOVE WS-IP TO IP-ADDRESS(WS-IP-INDEX)
               ADD 1 TO IP-COUNT(WS-IP-INDEX)
           END-IF.

       CHECK-STATUS-COUNTS.
           MOVE 'N' TO WS-FOUND
           PERFORM VARYING WS-STATUS-INDEX FROM 1 BY 1 UNTIL WS-STATUS-INDEX > 100
               IF STATUS-CODE(WS-STATUS-INDEX) = WS-STATUS
                   ADD 1 TO STATUS-COUNT(WS-STATUS-INDEX)
                   MOVE 'Y' TO WS-FOUND
                   EXIT PERFORM
               END-IF
           END-PERFORM
           IF WS-FOUND = 'N'
               MOVE WS-STATUS TO STATUS-CODE(WS-STATUS-INDEX)
               ADD 1 TO STATUS-COUNT(WS-STATUS-INDEX)
           END-IF.

       GENERATE-REPORT.
           DISPLAY "Log Analysis Report"
           DISPLAY "=================="
           DISPLAY "Total requests: " TOTAL-REQUESTS
           DISPLAY "Top 10 IP addresses:"
           PERFORM VARYING WS-IP-INDEX FROM 1 BY 1 UNTIL WS-IP-INDEX > 10
               IF IP-ADDRESS(WS-IP-INDEX) NOT = SPACES
                   DISPLAY IP-ADDRESS(WS-IP-INDEX) ": " IP-COUNT(WS-IP-INDEX) " requests"
               END-IF
           END-PERFORM
           DISPLAY "Status code summary:"
           PERFORM VARYING WS-STATUS-INDEX FROM 1 BY 1 UNTIL WS-STATUS-INDEX > 100
               IF STATUS-CODE(WS-STATUS-INDEX) NOT = SPACES
                   DISPLAY "HTTP " STATUS-CODE(WS-STATUS-INDEX) ": " STATUS-COUNT(WS-STATUS-INDEX) " requests"
               END-IF
           END-PERFORM.
```