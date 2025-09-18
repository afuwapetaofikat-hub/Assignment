CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    genre VARCHAR(50),
    published_year INT,
    available_copies INT NOT NULL CHECK (available_copies >= 0)
);


CREATE TABLE Members (
    member_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    membership_date DATE DEFAULT CURRENT_DATE
);


CREATE TABLE Borrow_Records (
    record_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL REFERENCES Members(member_id),
    book_id INT NOT NULL REFERENCES Books(book_id),
    borrow_date DATE NOT NULL,
    return_date DATE
);

--Insert data into Books

INSERT INTO Books (title, author, genre, published_year, available_copies) VALUES
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 5),
('1984', 'George Orwell', 'Dystopian', 1949, 3),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 4),
('Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 6),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 7),
('Becoming', 'Michelle Obama', 'Biography', 2018, 2),
('Thinking, Fast and Slow', 'Daniel Kahneman', 'Psychology', 2011, 3),
('The Lean Startup', 'Eric Ries', 'Business', 2011, 5),
('Clean Code', 'Robert C. Martin', 'Technology', 2008, 4),
('Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 'History', 2011, 6);


--Insert data into Members

INSERT INTO Members (name, email, phone_number) VALUES
('Afuwape Taofikat', 'taofikat@mail.com', '+2348012345678'),
('Ade Ola', 'ade.ola@mail.com', '+2348098765432'),
('Chinedu Okafor', 'chinedu.okafor@mail.com', '+2348076543210'),
('Fatima Bello', 'fatima.bello@mail.com', '+2348054321987'),
('Samuel Johnson', 'samuel.johnson@mail.com', '+2348032145678');

--Insert data into Members

INSERT INTO Borrow_Records (member_id, book_id, borrow_date, return_date) VALUES
(1, 3, '2025-08-01', '2025-08-15'),
(2, 1, '2025-08-03', '2025-08-18'),
(3, 5, '2025-08-05', '2025-08-20'),
(4, 2, '2025-08-07', '2025-08-21'),
(5, 4, '2025-08-09', '2025-08-25'),
(1, 6, '2025-08-12', '2025-08-28'),
(2, 7, '2025-08-15', '2025-09-01'),
(3, 8, '2025-08-18', '2025-09-03'),
(4, 9, '2025-08-20', '2025-09-05'),
(5, 10, '2025-08-22', '2025-09-07');

--Retrieve all books sorted by title

SELECT * 
FROM Books
ORDER BY title;

--Retrieve members who joined after January 1, 2025

SELECT * 
FROM Members
WHERE membership_date > '2025-01-01';

--Find all books by Harper Lee

SELECT * 
FROM Books
WHERE author = 'Harper Lee';

--Find all books with available copies > 0

SELECT * 
FROM Books
WHERE available_copies > 0;

--Retrieve borrowing records with member names and book titles

SELECT br.record_id, m.name AS member_name, b.title AS book_title, br.borrow_date, br.return_date
FROM Borrow_Records AS br
JOIN Members AS m ON br.member_id = m.member_id
JOIN Books AS b ON br.book_id = b.book_id;

--Find members who have not returned their books
SELECT m.name, b.title
FROM Borrow_Records AS br
JOIN Members AS m ON br.member_id = m.member_id
JOIN Books AS b ON br.book_id = b.book_id
WHERE br.return_date IS NULL;

--Count the total number of books

SELECT COUNT(*) AS total_books
FROM Books;

--Find the most borrowed book

SELECT b.title, COUNT(br.book_id) AS borrow_count
FROM Borrow_Records AS br
JOIN Books AS b ON br.book_id = b.book_id
GROUP BY b.title
ORDER BY borrow_count DESC;


--Update available copies of a book when borrowed

UPDATE Books
SET available_copies = available_copies - 1
WHERE book_id = 1;

--Update available copies of a book when returned

UPDATE Books
SET available_copies = available_copies + 1
WHERE book_id = 1;

--Delete a member’s record

DELETE FROM Borrow_Records
WHERE member_id = 2;

DELETE FROM Members
WHERE member_id = 2;

--Retrieve the top 3 members who borrowed the most books

SELECT Members.name, COUNT(Borrow_Records.record_id) AS borrow_count
FROM Members
JOIN Borrow_Records ON Members.member_id = Borrow_Records.member_id
GROUP BY Members.name
ORDER BY borrow_count DESC
LIMIT 3;

--Find all books that have not been borrowed
SELECT Books.title
FROM Books
LEFT JOIN Borrow_Records ON Books.book_id = Borrow_Records.book_id
WHERE Borrow_Records.book_id IS NULL;




