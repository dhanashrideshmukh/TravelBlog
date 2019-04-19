--
-- Table structure for table `userfeedback`
--

CREATE TABLE `userfeedback` (
  `FeedbackID` int(11) NOT NULL,
  `FullName` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `Email` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `CreatedDate` date DEFAULT NULL,
  `Comments` varchar(500) COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

ALTER TABLE `userfeedback`
  ADD PRIMARY KEY (`FeedbackID`);

--
-- AUTO_INCREMENT for table `userfeedback`
--
ALTER TABLE `userfeedback`
  MODIFY `FeedbackID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;


