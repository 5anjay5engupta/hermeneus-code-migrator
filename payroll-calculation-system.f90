! FORTRAN payroll calculation system
PROGRAM PayrollCalculation
  IMPLICIT NONE
  CHARACTER(LEN=100) :: employee
  REAL :: hours, rate, overtime, regularPay, overtimePay
  REAL :: grossPay, tax, netPay

  ! Prompt for employee name
  PRINT *, 'Enter employee name: '
  READ(*, '(A)') employee

  ! Prompt for hours worked
  PRINT *, 'Enter hours worked: '
  READ(*, *) hours

  ! Prompt for hourly rate
  PRINT *, 'Enter hourly rate: '
  READ(*, *) rate

  ! Calculate regular and overtime pay
  IF (hours <= 40.0) THEN
    regularPay = hours * rate
    overtimePay = 0.0
  ELSE
    overtime = hours - 40.0
    regularPay = 40.0 * rate
    overtimePay = overtime * rate * 1.5
  END IF

  ! Calculate gross pay, tax, and net pay
  grossPay = regularPay + overtimePay
  tax = grossPay * 0.15
  netPay = grossPay - tax

  ! Output the results
  PRINT *, 'Employee: ', TRIM(employee)
  PRINT *, 'Hours worked: ', hours
  PRINT *, 'Regular pay: $', regularPay
  PRINT *, 'Overtime pay: $', overtimePay
  PRINT *, 'Gross pay: $', grossPay
  PRINT *, 'Tax deduction: $', tax
  PRINT *, 'Net pay: $', netPay

END PROGRAM PayrollCalculation
```