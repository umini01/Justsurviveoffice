package com.spring.app.board.service;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.cache.annotation.Cacheable;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.category.domain.CategoryDTO;
import com.spring.app.comment.domain.CommentDTO;

public interface BoardService {

	// 인기 게시글 리스트 (조회수 많은 순)
	@Cacheable("hotReadList")
	public List<BoardDTO> getTopBoardsByViewCount();
	
	// 댓글 많은 게시글 리스트
	@Cacheable("hotCommentList")
	public List<BoardDTO> getTopBoardsByCommentCount();
	//////////////////////////////////////////////////////////////////////////

	// 게시글 업로드 메소드
	public int insertBoard(BoardDTO boardDto);
	
	// 게시물의 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	public List<BoardDTO> boardList(Map<String, String> paraMap);
	
	// 카테고리별 게시물이 3개씩 있는 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	public List<BoardDTO> boardListAll(Map<String, String> paraMap);
	
	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	public BoardDTO selectView(Long boardNo);
	
	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	public int deleteBoard(Long boardNo);
	
	// 스마트에디터파일을 DB에서 받아와, List로 반환하기.
	public List<String> fetchPhoto_upload_boardFileNameList(Long boardNo);
		
	// 게시물 수정하기 
	public int updateBoard(BoardDTO boardDto);
	
	// 조회수 증가시키기! ip측정 및 스케줄러는 컨트롤러&서비스에서!
	public int updateReadCount(Long boardNo);
	
    // 내가 작성한 글 목록
//	public List<BoardDTO> getMyBoards(String fk_id);

	// 내가 작성한 글 목록 스크롤
	public List<BoardDTO> myBoardsScroll(Map<String, Object> paramMap);
	
    // 북마크한 게시글 목록
    public List<BoardDTO> getBookmarksById(String fk_id);

	public List<CommentDTO> getCommentList(Long boardNo);

	//게시물 좋아요 여부 확인
	public boolean isBoardLiked(String fk_id, Long fk_boardNo) ;

	//게시물 좋아요 취소
	public int deleteBoardLike(String fk_id, Long fk_boardNo) ;

	//게시물 좋아요
	public int insertBoardLike(String fk_id, Long fk_boardNo) ;

    // 좋아요 수 
	public int getBoardLikeCount(Long fk_boardNo);

	// 메인페이지 카테고리 자동 불러오기 메서드
	public List<CategoryDTO> getIndexList();

	// 페이지네이션 구현
	public BoardDTO getView(Long boardNo);

	// 총 검색된 게시물 건수
	public int searchListCount(Map<String, String> paraMap);
	
	// 자동 검색어 완성시키기
	public List<Map<String, String>> getSearchWordList(Map<String, String> paraMap);
	
	// == 키워드 메소드 작성 해봄 == // 
	public List<Map<String, Object>> getKeyWord(String category);
	
	// 마이페이지 게시글 복구하기
	public int recoveryBoard(String boardNo);


//	
//	// 유저가 하루동안 쓴 글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
//	public int getCreatedAtBoardCnt(String id);

	
}