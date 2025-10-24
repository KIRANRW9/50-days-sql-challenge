-- Day 44: Conversion Funnel Analysis
-- Create Funnel table
CREATE TABLE Funnel (
    user_id INT NOT NULL,
    stage VARCHAR(50) NOT NULL,
    timestamp DATETIME NOT NULL,
    PRIMARY KEY (user_id, stage)
);

-- Insert sample data into Funnel
-- Users with complete funnel (visit → sign_up → purchase)
INSERT INTO Funnel VALUES
(1, 'visit', '2024-01-01 10:00:00'),
(1, 'sign_up', '2024-01-01 10:05:00'),
(1, 'purchase', '2024-01-01 10:15:00'),

(4, 'visit', '2024-01-01 13:00:00'),
(4, 'sign_up', '2024-01-01 13:05:00'),
(4, 'purchase', '2024-01-01 13:20:00'),

(8, 'visit', '2024-01-02 11:00:00'),
(8, 'sign_up', '2024-01-02 11:45:00'),
(8, 'purchase', '2024-01-02 12:30:00'),

(11, 'visit', '2024-01-03 08:00:00'),
(11, 'sign_up', '2024-01-03 08:02:00'),
(11, 'purchase', '2024-01-03 08:10:00'),

(17, 'visit', '2024-01-03 14:00:00'),
(17, 'sign_up', '2024-01-03 14:10:00'),
(17, 'purchase', '2024-01-03 14:25:00');

-- Users with partial funnel (visit → sign_up, no purchase)
INSERT INTO Funnel VALUES
(2, 'visit', '2024-01-01 11:00:00'),
(2, 'sign_up', '2024-01-01 11:10:00'),

(6, 'visit', '2024-01-02 09:00:00'),
(6, 'sign_up', '2024-01-02 09:15:00'),

(9, 'visit', '2024-01-02 14:00:00'),
(9, 'sign_up', '2024-01-02 14:20:00'),

(16, 'visit', '2024-01-03 13:00:00'),
(16, 'sign_up', '2024-01-03 13:30:00');

-- Users with early drop-off (visit only, no sign_up or purchase)
INSERT INTO Funnel VALUES
(3, 'visit', '2024-01-01 12:00:00'),
(5, 'visit', '2024-01-01 14:00:00'),
(7, 'visit', '2024-01-02 10:30:00'),
(10, 'visit', '2024-01-02 15:00:00'),
(12, 'visit', '2024-01-03 09:00:00'),
(13, 'visit', '2024-01-03 10:00:00'),
(14, 'visit', '2024-01-03 11:00:00'),
(15, 'visit', '2024-01-03 12:00:00'),
(18, 'visit', '2024-01-04 08:00:00'),
(19, 'visit', '2024-01-04 09:00:00'),
(20, 'visit', '2024-01-04 10:00:00');
