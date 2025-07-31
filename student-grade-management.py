# Python student grade management

class Student:
    def __init__(self, student_id, name, grades):
        self.id = student_id
        self.name = name
        self.grades = grades
        self.average = 0.0

    def calculate_average(self):
        self.average = sum(self.grades) / len(self.grades)

def main():
    print('Student Grade Management System')
    student_count = int(input('Enter number of students: '))
    
    students = []
    
    for i in range(student_count):
        print(f'Enter student {i + 1} details:')
        student_id = int(input('ID: '))
        name = input('Name: ')
        
        grades = []
        for j in range(5):
            grade = float(input(f'Grade {j + 1}: '))
            grades.append(grade)
        
        student = Student(student_id, name, grades)
        student.calculate_average()
        students.append(student)
        
        print(f'Average: {student.average:.2f}')

if __name__ == "__main__":
    main()
```