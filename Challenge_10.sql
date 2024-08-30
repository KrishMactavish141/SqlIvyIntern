use ivyintership_db;

set sql_safe_updates=0;
update subjects
set Pass_Marks = 40 where ID = 'S6';
  
SELECT 
    s.Roll_Number,
    s.Name,
    ROUND(
        (GREATEST(sc.Subject5, sc.Subject6) + sc.Subject1 + sc.Subject2 + sc.Subject3 + sc.Subject4) / 5.0,
        2
    ) AS Percentage_marks,
    GROUP_CONCAT(sub.Subject) AS Failed_subjects,
    CASE
        WHEN COUNT(sub.ID) = 0 THEN 'Passed'
        ELSE 'Failed'
    END AS Status
FROM 
    Students s
JOIN 
    Scores sc ON s.Roll_Number = sc.Student_ID
LEFT JOIN 
    Subjects sub ON (
        (sub.ID = 'S1' AND sc.Subject1 < sub.Pass_Marks) OR
        (sub.ID = 'S2' AND sc.Subject2 < sub.Pass_Marks) OR
        (sub.ID = 'S3' AND sc.Subject3 < sub.Pass_Marks) OR
        (sub.ID = 'S4' AND sc.Subject4 < sub.Pass_Marks) OR
        (sub.ID = 'S5' AND sc.Subject5 < sub.Pass_Marks) OR
        (sub.ID = 'S6' AND sc.Subject6 < sub.Pass_Marks)
    )
GROUP BY 
    s.Roll_Number, s.Name, sc.Subject1, sc.Subject2, sc.Subject3, sc.Subject4, sc.Subject5, sc.Subject6
ORDER BY 
    Status DESC, Percentage_marks DESC;


select s.Roll_Number Roll_No, s.Name,
round((greatest(sc.Subject5, sc.Subject6) + sc.Subject1 + sc.Subject2 + sc.Subject3 + sc.Subject4) / 5.0,2) Percentage_marks,
ifnull(group_concat(sub.Subject),"Nothing") Failed_subjects,
case
when count(sub.ID) = 0 then 'Passed'
else 'Failed' end as Status
from Students s join Scores sc on s.Roll_Number = sc.Student_ID left join 
Subjects sub on ((sub.ID = 'S1' and sc.Subject1 < sub.Pass_Marks) or
(sub.ID = 'S2' and sc.Subject2 < sub.Pass_Marks) or (sub.ID = 'S3' and sc.Subject3 < sub.Pass_Marks) or
(sub.ID = 'S4' and sc.Subject4 < sub.Pass_Marks) or (sub.ID = 'S5' and sc.Subject5 < sub.Pass_Marks) or
(sub.ID = 'S6' and sc.Subject6 < sub.Pass_Marks))
group by s.Roll_Number, s.Name, sc.Subject1, sc.Subject2, sc.Subject3, sc.Subject4, sc.Subject5, sc.Subject6
order by 
Status desc, Percentage_marks desc;




SELECT 
    s.Roll_Number,
    s.Name,
    ROUND(
        (GREATEST(sc.Subject5, sc.Subject6) + sc.Subject1 + sc.Subject2 + sc.Subject3 + sc.Subject4) / 5.0,
        2
    ) AS Percentage_marks,
    GROUP_CONCAT(CASE 
                    WHEN (sub.ID = 'S1' AND sc.Subject1 < sub.Pass_Marks) OR
                         (sub.ID = 'S2' AND sc.Subject2 < sub.Pass_Marks) OR
                         (sub.ID = 'S3' AND sc.Subject3 < sub.Pass_Marks) OR
                         (sub.ID = 'S4' AND sc.Subject4 < sub.Pass_Marks) OR
                         (sub.ID = 'S5' AND sc.Subject5 < sub.Pass_Marks) OR
                         (sub.ID = 'S6' AND sc.Subject6 < sub.Pass_Marks) 
                    THEN sub.Subject 
                    ELSE NULL 
                END ORDER BY sub.ID ASC SEPARATOR ', ') AS Failed_subjects,
    CASE
        WHEN SUM(CASE 
                    WHEN (sub.ID = 'S1' AND sc.Subject1 < sub.Pass_Marks) OR
                         (sub.ID = 'S2' AND sc.Subject2 < sub.Pass_Marks) OR
                         (sub.ID = 'S3' AND sc.Subject3 < sub.Pass_Marks) OR
                         (sub.ID = 'S4' AND sc.Subject4 < sub.Pass_Marks) OR
                         (sub.ID = 'S5' AND sc.Subject5 < sub.Pass_Marks) OR
                         (sub.ID = 'S6' AND sc.Subject6 < sub.Pass_Marks)
                    THEN 1 ELSE 0 
                END) = 0 
        THEN 'Passed' 
        ELSE 'Failed' 
    END AS Status
FROM 
    Students s
JOIN 
    Scores sc ON s.Roll_Number = sc.Student_ID
LEFT JOIN 
    Subjects sub ON (
        (sub.ID = 'S1') OR
        (sub.ID = 'S2') OR
        (sub.ID = 'S3') OR
        (sub.ID = 'S4') OR
        (sub.ID = 'S5') OR
        (sub.ID = 'S6')
    )
GROUP BY 
    s.Roll_Number, s.Name, sc.Subject1, sc.Subject2, sc.Subject3, sc.Subject4, sc.Subject5, sc.Subject6
ORDER BY 
    Status DESC, Percentage_marks DESC;