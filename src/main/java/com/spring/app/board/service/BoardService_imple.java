package com.spring.app.board.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;
import java.util.Set;


import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.safety.Safelist;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.model.BoardDAO;
import com.spring.app.category.domain.CategoryDTO;
import com.spring.app.comment.domain.CommentDTO;
import com.spring.app.comment.model.CommentDAO;
import com.spring.app.common.FileManager;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardService_imple implements BoardService {

	private final BoardDAO boardDao;
    private final FileManager fileManager;
    private final CommentDAO commentDao;
	
    // 게시글 업로드 메소드
	@Override
	@Transactional(value="transactionManager_final_orauser2",
	   			   propagation=Propagation.REQUIRED, 
	   			   isolation=Isolation.READ_COMMITTED, 
	   			   rollbackFor = {Throwable.class})
	public int insertBoard(BoardDTO boardDto) {
		
		int result = 0;
		// SQL문 if 처리해도 되지만, service 단에서 처리하는 실무연습.
		if(boardDto.getBoardFileName() == null ||
		   "".equals(boardDto.getBoardFileName())) {
			// 파일첨부 안 된 경우.
			result = boardDao.insertBoard(boardDto);
		}
		else {
			// 파일첨부 된 경우.
			result = boardDao.insertBoardWithFile(boardDto);
		}
		return result;
	}

	// 게시물의 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	@Override
	public List<BoardDTO> boardList(Map<String, String> paraMap) {
		
		List<BoardDTO> boardList = boardDao.selectBoardList(paraMap);
		
		for(BoardDTO dto : boardList) {
			// 1. 텍스트 변환
			String textForBoardList = Jsoup.clean(dto.getBoardContent()
					.replaceAll("(?i)<br\\s*/?>", "\n")	// 대소문자 구분 없이, <br>, <br/>, <br >, <BR/> 같은 줄바꿈 태그를 전부 찾기, 및 공백 변환
					.replace("&nbsp;", " "), Safelist.none());
			dto.setTextForBoardList(textForBoardList.length() > 20
									? textForBoardList.substring(0,20) + "..."
									: textForBoardList);
			// 2. 이미지 체크 및 추출
			Element img = Jsoup.parse(dto.getBoardContent()).selectFirst("img[src]");	// import org.jsoup.nodes.Element;
			if (img != null) {
				String imgForBoardList = img.attr("src");
				dto.setImgForBoardList(imgForBoardList);
				System.out.println("스마트에디터이미지는 경로 >> " +imgForBoardList);
				System.out.println("첨부이미지는 경로 >> " +dto.getBoardFileName());
			} 
		}
		//이렇게 하지않으면, JSP가 HTML 스마트 에디터의 태그까지 문자열로 찍어주기 때문에 레이아웃이 깨짐!

		return boardList;
	}

	// 카테고리별 게시물이 3개씩 있는 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	@Override
	public List<BoardDTO> boardListAll(Map<String, String> paraMap) {
		List<BoardDTO> boardList = boardDao.selectBoardListAll(paraMap);
		
		for(BoardDTO dto : boardList) {
			// 1. 텍스트 변환
			String textForBoardList = Jsoup.clean(dto.getBoardContent()
					.replaceAll("(?i)<br\\s*/?>", "\n")	// 대소문자 구분 없이, <br>, <br/>, <br >, <BR/> 같은 줄바꿈 태그를 전부 찾기, 및 공백 변환
					.replace("&nbsp;", " "), Safelist.none());
			dto.setTextForBoardList(textForBoardList.length() > 20
									? textForBoardList.substring(0,20) + "..."
									: textForBoardList);
			// 2. 이미지 체크 및 추출
			Element img = Jsoup.parse(dto.getBoardContent()).selectFirst("img[src]");	// import org.jsoup.nodes.Element;
			if (img != null) {
				String imgForBoardList = img.attr("src");
				dto.setImgForBoardList(imgForBoardList);
			} 
		}
		//이렇게 하지않으면, JSP가 HTML 스마트 에디터의 태그까지 문자열로 찍어주기 때문에 레이아웃이 깨짐!

		return boardList;
	}
	
	
	// 스마트에디터파일을 DB에서 받아와, List로 반환하기.
	@Override
	public List<String> fetchPhoto_upload_boardFileNameList(Long boardNo) {
		BoardDTO dto = selectView(boardNo);
		// 스마트 에디터 이미지만 추출하기!
		Elements imgList = Jsoup.parse(dto.getBoardContent()).select("img[src]");
		// import org.jsoup.nodes.Elements;
		List<String> photo_upload_boardFileNameList = new ArrayList<>();
		for(Element img : imgList) {
			System.out.println(img);
			if (img != null) {
				String src = img.attr("src");
		        // 파일명만 추출: 마지막 "/" 뒤 문자만
		        String fileName = src.substring(src.lastIndexOf("/") + 1);
				photo_upload_boardFileNameList.add(fileName);
				System.out.println(fileName);
			}
		}
		return photo_upload_boardFileNameList;
	}

	
	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	@Override
	public BoardDTO selectView(Long boardNo) {

		BoardDTO boardDto = boardDao.selectView(boardNo);
		
		return boardDto;
	}

	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	@Override
	public int deleteBoard(Long boardNo) {
		
		int n = boardDao.softDeleteBoard(boardNo);
		
		return n;
	}

	// 조회수 증가시키기! ip측정 및 스케줄러는 컨트롤러&서비스에서!
	@Override
	public int updateReadCount(Long boardNo) {
		
		int n = boardDao.updateReadCount(boardNo);

		return n;
	}

	// 게시물 수정하기, 수정시 기존 파일은 삭제!
	@Override
	public int updateBoard(BoardDTO boardDto) {
		
		int n = boardDao.updateBoard(boardDto);

		return n;
	}
	
	// 메인페이지 카테고리 자동 불러오기 메서드
	@Override
	public List<CategoryDTO> getIndexList() {
		List<CategoryDTO> IndexList = boardDao.getIndexList();
		return IndexList;
	}


	@Override
	public BoardDTO getView(Long boardNo) {
		BoardDTO boardDto = boardDao.getView(boardNo);
			
		return boardDto;
	}

	//내가 작성한 글 목록
//  @Override
//  public List<BoardDTO> getMyBoards(String fk_id) {
//    	return boardDao.getMyBoards(fk_id);
//  }
	   
   	// 내가 작성한 글 목록 스크롤
	@Override
    public List<BoardDTO> myBoardsScroll(Map<String, Object> paramMap) {
		return boardDao.myBoardsScroll(paramMap);
    }

    // 북마크한 글 목록
    @Override
    public List<BoardDTO> getBookmarksById(String fk_id) {
        return boardDao.getBookmarksById(fk_id);
    }

    
    // 댓글목록
	@Override
	public List<CommentDTO> getCommentList(Long boardNo) {
	 	List<CommentDTO> commentList = commentDao.getCommentList(boardNo);
		 
	 	for (CommentDTO comment : commentList) {
	 		List<CommentDTO> replies = commentDao.getRepliesByParentNo(comment.getCommentNo());
	 		comment.setReplyList(replies);
	    }

	    return commentList;
	}

	
	////////////////////////////////////////////////////////////////////////////////////
	// 인기 게시글 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> getTopBoardsByViewCount() {
		List<BoardDTO> hotReadList = boardDao.getTopBoardsByViewCount();
		return hotReadList;
	}
	
	
	// 댓글 많은 게시글 리스트
	@Override
	public List<BoardDTO> getTopBoardsByCommentCount() {
		List<BoardDTO> hotCommentList = boardDao.getTopBoardsByCommentCount();
		return hotCommentList;
	}

	
	////////////////////////////////////////////////////////////////////////////////////   
	
	
	//게시글 좋아요 여부
	@Override
	public boolean isBoardLiked(String fk_id, Long fk_boardNo) {
		 
		Map<String, Object> paramMap = new HashMap<>();
		
		paramMap.put("fk_id", fk_id);
		paramMap.put("fk_boardNo", fk_boardNo);
		
		int count = boardDao.isBoardLiked(paramMap);
	    return count > 0; // 좋아요가 존재하면 true			
	}

	//게시글 좋아요 취소
	@Override
	public int deleteBoardLike(String fk_id, Long fk_boardNo) {
	    return boardDao.deleteBoardLike(fk_id, fk_boardNo);

		
	}

	//게시글 좋아요 추가
	@Override
	public int insertBoardLike(String fk_id, Long fk_boardNo) {
		int n = boardDao.insertBoardLike( fk_id,fk_boardNo );
		return n;
	}
	

	//게시글 좋아요 수
	@Override
	public int getBoardLikeCount(Long fk_boardNo) {
		return boardDao.getLikeCount(fk_boardNo);
	}
		
	

	
	// 총 검색된 게시물 건수
	@Override
	public int searchListCount(Map<String, String> paraMap) {
		int n = boardDao.searchListCount(paraMap);
		return n;
	}
	
	// 자동 검색어 완성시키기
	@Override
	public List<Map<String, String>> getSearchWordList(Map<String, String> paraMap) {
		
		List<String> wordList = boardDao.getSearchWordList(paraMap);	// 자동 검색어 완성시킬 제목 or 이름 가져오기
		
		List<Map<String, String>> mapList = new ArrayList<>();
		
		if(wordList != null) {
			for(String word : wordList) {
				Map<String, String> map = new HashMap<>();
				map.put("word", word);
				System.out.println(word);
				mapList.add(map);
			}// end of for-----------------
		}
		
		return mapList;
	}
	
	// == 키워드 메소드 작성 해봄 == // 
	@Override
	public List<Map<String, Object>> getKeyWord(String category) {
		
		// 키워드 테이블에서 데이터 가져오기
		List<Map<String, Object>> keyword_top = boardDao.getBoardContents(category);
		
		return keyword_top;
	}
	
	// 마이페이지 게시글 복구하기
	@Override
	public int recoveryBoard(String boardNo) {
		int data = boardDao.recoveryBoard(boardNo);
		return data;
	}


	
//	// 유저가 하루동안 쓴 글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
//	@Override
//	public int getCreatedAtBoardCnt(String id) {
//		return boardDao.getCreatedAtBoardCnt(id);
//	}

	
	
}