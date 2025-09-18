package com.spring.app.users.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Optional;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.app.category.domain.CategoryDTO;
import com.spring.app.common.AES256;
import com.spring.app.common.SecretMyKey;
import com.spring.app.common.Sha256;
import com.spring.app.entity.Category;
import com.spring.app.entity.LoginHistory;
import com.spring.app.entity.Users;
import com.spring.app.model.HistoryRepository;
import com.spring.app.model.UsersRepository;
import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.users.domain.UsersDTO;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UsersService_imple implements UsersService {

   private final UsersRepository usersRepository;
   private final HistoryRepository historyRepository;
   

   private AES256 aes;

       

   @Override
   public UsersDTO getUser(String id, String Pwd) {
         
     UsersDTO usersDto = null;
         
     try {
        Optional<Users> user = usersRepository.findById(id);	// 카테고리 포함 데이터 가져오기
   /*   Java8에서는 Optional<T> 클래스를 사용해 NullPointerException 을 방지할 수 있도록 도와준다. 
        Optional<T>는 null이 올 수 있는 값을 감싸는 Wrapper 클래스 이므로, 참조하더라도 NullPointerException 이 발생하지 않도록 도와준다. 
        Optional 클래스는 null 이더라도 바로 NullPointerException 이 발생하지 않으며, 클래스이기 때문에 각종 메소드를 제공해준다. */
        aes = new AES256(SecretMyKey.KEY);
        
        Users users = user.get();
        // java.util.Optional.get() 은 값이 존재하면 값을 리턴시켜주고, 값이 없으면 NoSuchElementException 을 유발시켜준다.
        
        try {
        	usersDto = users.toDTO();
        	System.out.println(usersDto.getId());
        	System.out.println(Sha256.encrypt(Pwd));
        	// usersDto.setPassword(Sha256.encrypt(Pwd));
          
          	// 복호화해서 DTO에 담기
	        usersDto.setEmail(aes.decrypt(users.getEmail()));
	        usersDto.setMobile(aes.decrypt(users.getMobile()));
	        usersDto.setPoint((users.getPoint()));
        } catch (Exception e) {   
          e.printStackTrace();
       }
        
     } catch(NoSuchElementException e) {
        // member.get() 에서 데이터가 존재하지 않는 경우
     } catch (Exception e) {
		e.printStackTrace();
	}
     return usersDto;
  } 

   
   // 아이디 중복 체크
   @Override
   public boolean isIdExists(String id) {
      return usersRepository.existsById(id);
   }


   // 이메일 중복 체크
   @Override
   public boolean isEmailExists(String email) {
	   try {
	        aes = new AES256(SecretMyKey.KEY);
	        String encryptedEmail = aes.encrypt(email);
	        return usersRepository.existsByEmail(encryptedEmail);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
   

   // 회원가입
   @Override
   public void registerUser(Users user) {
      try {
         aes = new AES256(SecretMyKey.KEY);
         user.setMobile(aes.encrypt(user.getMobile()));
         user.setEmail(aes.encrypt(user.getEmail()));
         user.setPassword(Sha256.encrypt(user.getPassword()));
         user.setRole("USER"); //DB에 접근하지 않는 한, 반드시 유저권한으로 세팅
      } catch (Exception e) {
         e.printStackTrace();
      }
      usersRepository.save(user);  // JPA가 DB에 저장해줌
   }


   // 비밀번호 업데이트
   @Override
   public void updatePassword(String id, String newPassword) {
	   
       Users user = usersRepository.findById(id).orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
       
       user.setPassword(Sha256.encrypt(newPassword));
      
       user.setPasswordChanged(LocalDateTime.now());   // 변경일 갱신
       user.setIsDormant(0);                           // 휴면 해제

       usersRepository.save(user);
   }

   //회원 수정하기
   @Override
   public UsersDTO updateUser(UsersDTO userDto) {
       Users user = usersRepository.findById(userDto.getId())
               .orElseThrow(() -> new RuntimeException("회원 정보를 찾을 수 없습니다."));

       try {
           aes = new AES256(SecretMyKey.KEY);
           user.setName(userDto.getName());
           user.setEmail(aes.encrypt(userDto.getEmail()));
           user.setMobile(aes.encrypt(userDto.getMobile()));

           if (userDto.getPassword() != null && !userDto.getPassword().isEmpty()) {
               user.setPassword(Sha256.encrypt(userDto.getPassword()));
               user.setPasswordChanged(LocalDateTime.now());
           }

           Users saved = usersRepository.save(user);

           // 복호화해서 DTO로 반환
           UsersDTO dto = saved.toDTO();
           dto.setEmail(aes.decrypt(saved.getEmail()));
           dto.setMobile(aes.decrypt(saved.getMobile()));
           return dto;

       } catch (Exception e) {
           e.printStackTrace();
           return null;
       }
   }
      
   //이메일 중복확인
   @Override
   public boolean isEmailDuplicated(String email) {
	   try {
	        aes = new AES256(SecretMyKey.KEY);
	        String encryptedEmail = aes.encrypt(email);
	        return usersRepository.existsByEmail(encryptedEmail);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}

   //회원탈퇴하기
   @Override
   public int delete(String id) {
      
      int n = 0;
      
      try {
         n = usersRepository.updateIsDeletedById(id);
      } catch (EmptyResultDataAccessException e) {
      }
      return n;
   }
   
   // loginHistory의 user엔티티 생성용 메소드
   @Override
   public Users toEntity(UsersDTO userDto) {
       return Users.builder()
               .id(userDto.getId())
               .password(userDto.getPassword())
               .build();
   }

   @Override
   public void saveLoginHistory(LoginHistoryDTO loginHistoryDTO) {
	   LoginHistory loginHistory = LoginHistory.builder()
                                  .lastLogin(loginHistoryDTO.getLastLogin())
                                  .ip(loginHistoryDTO.getIp())
                                  .users(loginHistoryDTO.getUsers())
                                  .build();
	   historyRepository.save(loginHistory);
    }


    @Override
    public UsersDTO getIdFind(String name, String email) {
    	
    	String encryptEmail = "";
    	
    	try {
    		aes = new AES256(SecretMyKey.KEY);
    		encryptEmail = aes.encrypt(email.trim());
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
    	
        return usersRepository.findByNameAndEmail(name.trim(), encryptEmail)
        					  .map(Users::toDTO) // Users 엔티티에 toDTO() 있다고 가정
    					  	  .orElse(null);
    }
    
    // 유저 존재 여부 확인
    @Override
    public Users findByIdAndEmail(String id, String email) {
    	String encryptEmail = "";
    	try {
    		aes = new AES256(SecretMyKey.KEY);
    		encryptEmail = aes.encrypt(email.trim());
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
    	return usersRepository.findByIdAndEmail(id, encryptEmail);
    }

    //휴면처리하기 ( 비밀번호변경대상 )
    @Override
    public boolean updateDormantStatus(String id) {
         
       Users users = usersRepository.findById(id).orElse(null);
       //orElse는 객체꺼내기를 시도할때 값이 없으면 null 을 반환하라는 뜻 !
      
       LocalDateTime now = LocalDateTime.now();
      
       if(users.getPasswordChanged() == null || 
          users.getPasswordChanged().isBefore(now.minusYears(1))) {
            
          users.setIsDormant(1);
          usersRepository.save(users);
         
          return true;
       }
       return false;
    }

    // 게시글을 쓰거나 댓글을 달면 해당 포인트를 주는 메소드. 
	@Override
	public void getPoint(Map<String, String> paraMap) {
		String id = paraMap.get("id");
		int point = Integer.parseInt(paraMap.get("point"));
		
		Users users = usersRepository.findById(id).orElse(null);
		
		if(users != null) {
			users.setPoint( users.getPoint() + point ); 
			// 기존 포인트에 더해줄것!
			System.out.println(point+" 만큼 point 업로드 완료^^^");
			usersRepository.save(users);
		}
		else System.out.println("유저를 찾지못함. 포인트업로드 오류!");
	}
	

	// 카테고리별 게시물 통계
	@Override
	public List<CategoryDTO> categoryByBoard() {
		List<Object[]> boardPercentageList = usersRepository.categoryByBoard();
   		
   		List<CategoryDTO> result = new ArrayList<>();
   		for(Object[] obj : boardPercentageList) {
   			CategoryDTO categoryDto = CategoryDTO.builder()
   					.categoryName(String.valueOf(obj[0]))
   					.categoryImagePath(String.valueOf(obj[1]))
   					.cnt(((Number) obj[2]).longValue())
   					.percentage(((Number) obj[3]).doubleValue())
   					.build();
   			result.add(categoryDto);
   		}
   		
   		return result;
	}


	// 카테고리별 인원수 통계
	@Override
	public List<CategoryDTO> categoryByUsers() {
		List<Object[]> usersPercentageList = usersRepository.categoryByUsers();
   		
		List<CategoryDTO> result = new ArrayList<>();
   		for(Object[] obj : usersPercentageList) {
   			CategoryDTO categoryDto = CategoryDTO.builder()
   					.categoryName(String.valueOf(obj[0]))
   					.cnt(((Number) obj[1]).longValue())
   					.percentage(((Number) obj[2]).doubleValue())
   					.categoryImagePath(String.valueOf(obj[3]))
   					.build();
   			result.add(categoryDto);
   		}
   		
   		return result;
	}

	
	@Override
    public List<Map<String, String>> registerChart(int year) {
        int[] bucket = new int[12];
        List<UsersRepository.MonthCount> rows = usersRepository.findByMonthRegister(year);

        for (UsersRepository.MonthCount r : rows) {
            int idx = Integer.parseInt(r.getMm()) - 1; // "01" -> 0
            bucket[idx] = r.getCnt().intValue();
        }

        List<Map<String, String>> result = new ArrayList<>(12);
        for (int i = 1; i <= 12; i++) {
            Map<String, String> row = new LinkedHashMap<>();
            row.put("mm", String.format("%02d", i));
            row.put("cnt", String.valueOf(bucket[i - 1]));
            result.add(row);
        }
        return result;
    }

	@Override	
    public List<Map<String, String>> registerChartday(int month) {
        int[] bucket = new int[31];
        List<UsersRepository.DayCount> rows = usersRepository.findBydayRegister(month);
        
        for (UsersRepository.DayCount r : rows) {
            int idx = Integer.parseInt(r.getDd())-1; // "01" -> 0
            bucket[idx] = r.getCnt().intValue();
        }

        List<Map<String, String>> result = new ArrayList<>(31);
        for (int i = 1; i <= 31; i++) {
            Map<String, String> row = new LinkedHashMap<>();
            row.put("dd", String.format("%02d", i));
            row.put("cnt", String.valueOf(bucket[i - 1]));
            result.add(row);
        }
        return result;
     }


	 @Override
	 public UsersDTO saveCategoryNo(String id, Long categoryNo) {
	     Users users = usersRepository.findById(id).orElse(null);
	     UsersDTO usersDto = null;
	     if (users != null) {
	         // 카테고리 엔티티 프록시 생성 (DB 조회 안 함)
	         Category category = new Category();
	         category.setCategoryNo(categoryNo);

	         // Users 엔티티에 카테고리 세팅
	         users.setCategory(category);
	         
	         usersRepository.save(users); // 카테고리가 세팅된 유저 자체를 저장!
	         
	         try {
	        	 users = usersRepository.findById(id).orElse(null);	// 카테고리 포함 데이터 가져오기
	             aes = new AES256(SecretMyKey.KEY);
	             
	             try {
	             	usersDto = users.toDTO();
	               	// 복호화해서 DTO에 담기
	     	        usersDto.setEmail(aes.decrypt(users.getEmail()));
	     	        usersDto.setMobile(aes.decrypt(users.getMobile()));
	     	        usersDto.setPoint((users.getPoint()));
	             } catch (Exception e) {   
	               e.printStackTrace();
	            }
	          } catch(NoSuchElementException e) {
	             // users 데이터가 존재하지 않는 경우
	          } catch (Exception e) {
	     		e.printStackTrace();
	     	  }
	     }
	     return usersDto;
	 }
	 // 엑셀 저장
	 @Override
	 public void userExcelList_to_Excel(String chart, Integer month, Model model) {
		
		 SXSSFWorkbook workbook = new SXSSFWorkbook();
			
		 // 시트생성
		 SXSSFSheet sheet = workbook.createSheet("회원가입 통계 정보");
		 
		// 시트 열 너비 설정
		sheet.setColumnWidth(0, 2000);
		sheet.setColumnWidth(1, 4000);
		sheet.setColumnWidth(2, 2000);
		
		// 행의 위치를 나타내는 변수
		int rowLocation = 0;
		
		// 병합할 행 만들기
		Row mergeRow = sheet.createRow(rowLocation); // 엑셀에서 행의 시작은 0 부터 시작한다.
		
		// 병합할 행에 "회원가입 통계 정보" 로 셀을 만들어 셀에 스타일을 주기
		for(int i=0; i<3; i++) {
			Cell cell = mergeRow.createCell(i);
			cell.setCellValue("회원가입 통계 정보");
		} // end of for
		
		// 셀 병합하기
		sheet.addMergedRegion(new CellRangeAddress(rowLocation, rowLocation, 0, 2)); // 시작 행, 끝 행, 시작 열, 끝 열
		
		// 헤더 행 만들기
		Row headerRow = sheet.createRow(++rowLocation); // 엑셀에서 행의 시작은 0 부터 시작한다.
														// ++rowLocation 은 전위연산자임.
		
		// 헤더 행의 첫번째 열 셀 만들기
		Cell headerCell = headerRow.createCell(0);
		headerCell.setCellValue("registerDay".equals(chart) ? "일" : "월");
		
		// 헤더 행의 두번째 열 셀 만들기
		headerCell = headerRow.createCell(1);
		headerCell.setCellValue("가입자수");
		
		// 헤더 행의 세번째 열 셀 만들기
		headerCell = headerRow.createCell(2);
		headerCell.setCellValue("퍼센티지");
		
		// ==== 데이터 조회 ==== //
		List<Map<String, String>> statList;

		if ("registerDay".equals(chart)) {
		    statList = (month == null) ? registerChartday() : registerChartday(month);
		} else {
		    statList = registerChart(); // 월별은 month 무시
		}

	    int total = statList.stream()
	                        .mapToInt(row -> Integer.parseInt(row.get("cnt")))
	                        .sum();
	    
	    // 오른쪽 정렬 스타일 적용
	    CellStyle rightAlignStyle = workbook.createCellStyle();
	    rightAlignStyle.setAlignment(HorizontalAlignment.RIGHT);
	    
	    // ==== 데이터 행 ====
	    for (int i = 0; i < statList.size(); i++) {
	        Map<String, String> rowMap = statList.get(i);
	        Row bodyRow = sheet.createRow(i + (rowLocation + 1));

	        // ✅ 월/일 구분
	        if ("registerDay".equals(chart)) {
	            bodyRow.createCell(0).setCellValue(rowMap.get("dd"));
	        } else {
	            bodyRow.createCell(0).setCellValue(rowMap.get("mm"));
	        }

	        // 가입자수
	        Cell cntCell = bodyRow.createCell(1);
	        cntCell.setCellValue(rowMap.get("cnt") + "명");
	        cntCell.setCellStyle(rightAlignStyle);
	        
	        // 퍼센티지
	        double percent = (total > 0)
	                ? (Double.parseDouble(rowMap.get("cnt")) * 100.0 / total)
	                : 0.0;
	        bodyRow.createCell(2).setCellValue(String.format("%.2f%%", percent));
	    }
	    
	    // ==== 합계 행 추가 ====
	    Row totalRow = sheet.createRow(statList.size() + (rowLocation + 1));

	    // 첫 번째 열: "합계"
	    totalRow.createCell(0).setCellValue("합계");

	    // 두 번째 열: 총 가입자 수
	    Cell totalCntCell = totalRow.createCell(1);
	    totalCntCell.setCellValue(total + "명");
	    totalCntCell.setCellStyle(rightAlignStyle);

	    // 세 번째 열: 퍼센티지 합계 (항상 100% 또는 0%)
	    totalRow.createCell(2).setCellValue(total > 0 ? "100.00%" : "0.00%");

	    // workbook을 model에 담아서 View에서 write
	    model.addAttribute("workbook", workbook);
	    
	    //  파일 이름 분기
	    String workbookName;
	    if ("registerDay".equals(chart)) {
	        // 일자별 통계
	        workbookName = (month != null) 
	            ? "일자별_가입자통계_" + month + "월" 
	            : "일자별_가입자통계";
	    } else {
	        // 월별 통계
	        workbookName = "월별_가입자통계";
	    }
	    model.addAttribute("workbookName", workbookName);
	}


}
