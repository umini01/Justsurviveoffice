package com.spring.app.springscheduler.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.springscheduler.model.SpringSchedulerDAO_final_orauser;
import com.spring.app.springscheduler.model.SpringSchedulerMapper_final_orauser;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SpringSechedulerService_imple implements SpringSechedulerService {
	
	// !!<주의>!! 스프링 스케줄러로 사용되는 메소드는 반드시 리턴다입은 void 이어야 하고, 파라미터가 없어야 한다.!!!!
	
/*	
	@Qualifier("SpringSchedulerDAO_final_orauser_imple")
	private final SpringSchedulerDAO_final_orauser dao_final_orauser;
*/	
	
	private final SpringSchedulerMapper_final_orauser mapper;
	
	
	// 매주 월요일 01:00 에 랭킹 테이블 초기화 및 업데이트 해주기
	@Override
	@Transactional(transactionManager = "transactionManager_final_orauser2")	// 한번이라도 sql 오류나면 롤백, mybatis 쓰므로 해당 트랜잭션매니저 이름 명시!
	@Scheduled(cron = "0 0 1 1 * *")
	public void weeklyRankingTable() {
		
		// 기존 보드 랭킹 테이블안에 내용 비워주기
	//	dao_final_orauser.deleteFromRank();
		mapper.deleteFromRank();
		
		// 보드 랭킹 테이블에 조회수 기준 새로운 데이터 넣기	
	//	int n = dao_final_orauser.insertGetTopBoardsByViewCount();
		int n = mapper.insertGetTopBoardsByViewCount();
		if(n <= 0) {
			throw new IllegalStateException("보드에 데이터가 없음!");		// 데이터가 없으면 오류 발생 후 메소드 종료
		}
		
		// 보드 랭킹 테이블에 댓글순 기준 새로운 데이터 넣기
	//	int m = dao_final_orauser.insertGetTopBoardsByCommentCount();
		int m = mapper.insertGetTopBoardsByCommentCount();
		if(m <= 0) {
			throw new IllegalStateException("보드에 데이터가 없음!");
		}
		
	}
	
	
	// 랭킹 테이블에 데이터 있는지 검사
	@Override
	@EventListener(ApplicationReadyEvent.class)	// ApplicationReadyEvent >> 스프링 부트에서 서버 시작하자마자 해당 이벤트 바로 실행시켜주게 해줌
	public void selectRankingTable() {
		
	//	int n = dao_final_orauser.selectRankBoard();
		int n = mapper.selectRankBoard();
		
		if(n == 0) {
			// 데이터가 없을 경우 초기화 실행
			weeklyRankingTable();
		}
	}
	
	
	// 매일 키워드 테이블 초기화 및 업데이트
	@Override
	@Transactional(transactionManager = "transactionManager_final_orauser2")
	@Scheduled(cron = "0 0 1 1 * *")
	public void selectRankingKeyword() {
		
		mapper.deleteFromKeyword();	// KEYWORD_RANKING 테이블 데이터 전부 제거
		
		List<Map<String, Object>> resultList = new ArrayList<>();
		
		// 카테고리 순회용도
        int[] categories = {1, 2, 3, 4, 5};
		
        for(int category : categories) {
        	
			// 해당 유형의 보드 테이블에서 제목과 내용, 가져오기(DB)
			List<Map<String, Object>> mapListKey = mapper.getgetBoardContents(category);
			
			// 키워드 넣을 리스트 생성
			List<String> keyword = new ArrayList<>();
			
			// DB에 가져온 게시글 제목과 내용을 하나의 문장으로 합치기
			for (Map<String, Object> map : mapListKey) {
				String name = map.get("boardName") == null ? "" : (String) map.get("boardName");	// 게시글 제목이 없다면 ""로 만들기
				String content = map.get("boardContent") == null ? "" : (String) map.get("boardContent"); // 게시글 내용이 없다면 ""로 만들기
				keyword.add(name + " " + content);	// 제목과 내용 사이에 공백을 하나두고 한문장으로 합치기
			}// end of for-------------------------
			
			// 1) HTML 대충 제거 & 소문자화 , 정규식 사용
			String keyword_check = String.join(" ", keyword)
					.replace("&nbsp;", " ")
					.toLowerCase()
					.replaceAll("<[^>]+>", " ")				// <p> 처럼 태그 형태 제거
					.replaceAll("[^0-9a-zA-Z가-힣]+", " ")	// 한글/영문/숫자 빼고 다 공백 처리 (잡다한 특수문자도 제거해줌)
					.replaceAll("\\s+", " ")				// \\s → 정규식에서 공백 문자(whitespace) 를 의미, 공백 정리
															// replaceAll("\\s+", " ") 은 연속된 모든 종류의 공백(스페이스/탭/줄바꿈 등)을 스페이스 하나 로 바꾸는 코드
					.trim();								// 문자열 시작과 끝의 공백만 날려줌
			
			// 2) 불용어(의미없는 단어) 및 길이 필터(아주 최소)
			Set<String> stop = Set.of("은","는","이","가","을","를","에","의","와","과","도","로","으로","하고","그리고","또는","더","것","수","등","및","the","and","or","to","of","in");
			// 의미 없는 단어 모음집 (stop) 만들기
			
			Map<String, Integer> keywordCount = new HashMap<>();	// 단어별 빈도 수 조사하기!
			
			for (String key : keyword_check.split(" ")) {	// 공백을 기준으로 나눠서 단어 집합 만들고 집합 순서별 단어 = key
				if (key.length() >= 2 && !stop.contains(key)) {	// 단어 길이 2이상 및 해당 단어가 stop 집합에 들어있는 단어가 포함인지 아닌지 체크하기
					keywordCount.merge(key, 1, Integer::sum);
					/*
						map.merge(key, value, remappingFunction)
						key → 찾을 키(예시: 단어)
						value → 기본값 (키가 없을 때 넣을 값) >> 해당 단어가 없을 때 추가해주고 value = 1 넣어주기 ("단어":1)
						remappingFunction → 키가 이미 있으면 (oldValue, value)를 받아서 새 값을 계산하는 함수 
						>> "상사":3 이라는 값이 저장 되었는데 "상사" 단어가 또 나오면 (3, 1) >> 3 + 1 로 계산해서 4로 저장하라는 것 ("상사":4)
						
						Integer::sum 뜻
						메서드 참조 문법 (Java 8)
						사실상 (oldVal, newVal) -> oldVal + newVal 람다랑 같음
						즉, 키가 이미 있으면 → 기존 값 + 새 값 으로 업데이트하라는 의미
					*/
				}
			}
			
			List<Map.Entry<String,Integer>> entryList = new ArrayList<>(keywordCount.entrySet());
			/*
				Map 안에서 "자바"=5 같이 Key와 Value가 묶여 있는 걸 Entry라고 불
				기존 Map은 키값을("자바") 알고 있으면 값을 반환해줌(5) 
				Map.Entry 는 "자바"=5 로 저장되어 그 맵을 a라고 표현할 때 a.getKey() / a.getValue() 문법을 통해서 "자바" 또는 5 라는 값을 얻을 수 있다.
				
				entrySet()
				map.entrySet() → Map 안에 있는 모든 Entry(=Key-Value 쌍) 를 모아둔 Set을 반환
				즉, Set<Map.Entry<K,V>> 타입
				예시 ["자바"=5, "스프링"=3]
				여기서 타입을 List<Map.Entry<K,V>> 형식으로 저장했는데 그 이유는 Set에는 순서 개념(정렬)이라는 것이 없어서 정렬하기 위해 List로 저장한 것이다.
			*/
			
			// 정렬: value 내림차순, 같으면 key 오름차순
			entryList.sort((a,b) -> {
				/*
					int result = comparator.compare(a, b);
					comparator.compare(a, b) 	>> a < b 이면 -1
												>> a = b 이면  0
												>> a > b 이면  1
					result < 0 → a가 b보다 앞에 와야 한다
					result == 0 → a와 b의 순서는 바뀌지 않는다 (동등)
					result > 0 → a가 b보다 뒤에 와야 한다
				*/
				// 값을 (a,b) 로 줬는데 compare(a.getValue(), b.getValue()) 라면 오름차순인데 아래는 거꾸로 되있으므로 내림차 순!
				int c = Integer.compare(b.getValue(), a.getValue());	// 벨류 값 비교해서 큰 값이 앞으로 옴 (내림차순) >> (3, 5) -> (5, 3)
				return (c != 0 ? c : a.getKey().compareTo(b.getKey()));	// 벨류 값이 같다면 compareTo는 문자열을 유니코드값 순서대로 비교
																		// a의 Key = "A", b의 key = "B" 라고 가정하자
																		// "A"의 유니코드 U+0041 / "B"의 유니코드 U+0042 >> B가 더 크므로 a가 b보다 앞에 와야 한다.
			});
			
			// 상위 3개만 뽑기
			List<Map.Entry<String,Integer>> keyword_top = entryList.subList(0, Math.min(3, entryList.size()));	// entryList의 크기가 3보다 작으면, 있는 만큼만 뽑음
			// subList >> 해당 리스트의 0번 째부터 Math.min(3, entryList.size()) 까지 잘라서 반환해주기
			// Math.min(3, entryList.size()) => 리스트 크기가 최대 3까지만 잘라올 것, 혹시나 entryList.size() 값이 3보다 작을 경우 대비해 해당 entryList.size() 값을 반환해줌!
			
			for(int i=0; i<keyword_top.size(); i++) {
				Map<String, Object> resultMap = new HashMap<>();
				resultMap.put("fk_categoryNo", category);
				resultMap.put("keyWord", keyword_top.get(i).getKey());
				resultMap.put("keyCount", keyword_top.get(i).getValue());
				resultList.add(resultMap);
			}
		}// end of for------------------------------------
		
		int n = mapper.insertGetKeyWord(resultList);	// 키워드테이블에 데이터 넣어주기
		if(n < 0) {
			throw new IllegalStateException("스케줄링 오류!");
		}
		
	}
	
	
	// 키워드 테이블에 데이터 있는지 검사
	@Override
	@EventListener(ApplicationReadyEvent.class)	// ApplicationReadyEvent >> 스프링 부트에서 서버 시작하자마자 해당 이벤트 바로 실행시켜주게 해줌
	public void selectKeywordTable() {
		
		int n = mapper.selectRank();
		
		if(n == 0) {
			// 데이터가 없을 경우 초기화 실행
			selectRankingKeyword();
		}
	}
	
}
