DELIMITER //
DROP PROCEDURE IF EXISTS Insert_Update_Calf_Wean_Info//
CREATE PROCEDURE Insert_Update_Calf_Wean_Info(input_calf_id varchar(20),input_date_weighed date,input_wean_weight float,input_manage_code varchar(20),input_wean_status varchar(20),
				input_hip_height float,input_date_measured date,input_contemp_grp varchar(20),input_muscle_grade varchar(2),input_frame_score float,input_lot varchar(2),input_weaning_notes text)
BEGIN
Declare input_chaps_id varchar(16);
Select chaps_id into input_chaps_id from cattle_info_tbl where animal_id=input_calf_id;
CASE WHEN  NOT EXISTS(select 1 from weaning_tbl where calf_id=input_calf_id) THEN 
	INSERT into weaning_tbl(chaps_id,calf_id,entry_date,manage_code,contemp_grp,muscle_grade) values(input_chaps_id,input_calf_id,input_date_weighed,input_manage_code,input_contemp_grp,input_muscle_grade);
	INSERT into measurement_tbl(chaps_id,calf_id,entry_date,weight,hip_height,frame_score,`status`,entry_type,lot_no) values(input_chaps_id,input_calf_id,input_date_weighed,input_wean_weight,input_hip_height,input_frame_score,input_wean_status,'W',input_lot);
	INSERT into notes_tbl(chaps_id,entry_date,note_type,notes) values(input_calf_id,CURDATE(),'W',input_weaning_notes);
ELSE
	UPDATE weaning_tbl 
			SET entry_date= CASE WHEN ISNULL(input_date_weighed) THEN entry_date ELSE input_date_weighed end ,
				manage_code=CASE WHEN ISNULL(input_manage_code) THEN manage_code ELSE input_manage_code end,
				contemp_grp=CASE WHEN ISNULL(input_contemp_grp) THEN contemp_grp ELSE input_contemp_grp end,
				muscle_grade=CASE WHEN ISNULL(input_muscle_grade) THEN muscle_grade ELSE input_muscle_grade end
	where Calf_ID=input_calf_id;
	UPDATE measurement_tbl 
			SET entry_date= CASE WHEN ISNULL(input_date_weighed) THEN entry_date ELSE input_date_weighed end ,
				weight=CASE WHEN ISNULL(input_wean_weight) THEN weight ELSE input_wean_weight end,
				hip_height=CASE WHEN ISNULL(input_hip_height) THEN hip_height ELSE input_hip_height end,
				frame_score=CASE WHEN ISNULL(input_frame_score) THEN frame_score ELSE input_frame_score  end,
				`status`=CASE WHEN ISNULL(input_wean_status) THEN `status` ELSE input_wean_status end,
				lot_no=CASE WHEN ISNULL(input_lot) THEN input_lot ELSE input_lot end
	where calf_id=input_calf_id;
	UPDATE notes_tbl 
			SET notes=(CASE WHEN NOT ISNULL(input_weaning_notes) THEN  input_weaning_notes end),
			entry_date=CURDATE() 
	where chaps_id=input_chaps_id and note_type='w';
END CASE;
END//

#Call Insert_CalfWeanInfo_byPK('1990-03-06','AN','dummy',null,null,20177,0,2,'0000-01-01',53,1,'H38',2,'first birth notes');

