package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.category.domain.CategoryDTO;

public interface BoardDAO {
	
	// 파일첨부 안 된 게시물 업로드
	public int insertBoard(BoardDTO boardDto);
	
	// 파일첨부 된 게시물 업로드
	public int insertBoardWithFile(BoardDTO boardDto);
	
	// 게시물의 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	public List<BoardDTO> selectBoardList(Map<String, String> paraMap);
	
	// 카테고리별 게시물이 3개씩 있는 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	public List<BoardDTO> selectBoardListAll(Map<String, String> paraMap);
	
	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	public BoardDTO selectView(Long boardNo);
	
	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	public int softDeleteBoard(Long boardNo);

	// 게시물 수정하기, 수정시 기존 파일은 삭제!
	public int updateBoard(BoardDTO boardDto);

	// 조회수 증가시키기! ip측정 및 스케줄러는 컨트롤러&서비스에서!
	public int updateReadCount(Long boardNo);
	

	// 메인페이지 카테고리 자동 불러오기
	public List<CategoryDTO> getIndexList();
////////////////////////////////////////////////////////////////////////////

	// 인기 게시글 리스트 (조회수 많은 순)
	List<BoardDTO> getTopBoardsByViewCount();
	   
	// 댓글 많은 게시글 리스트
	List<BoardDTO> getTopBoardsByCommentCount();
	
////////////////////////////////////////////////////////////////////////////

	// 페이지내이션 
	public BoardDTO getView(Long boardNo);

	//  내가 작성한 글 목록
//  List<BoardDTO> getMyBoards(String fk_id);
    public List<BoardDTO> myBoardsScroll(Map<String, Object> paramMap);

    //  북마크한 게시글 목록
    List<BoardDTO> getBookmarksById(String fk_id);

	// 게시물 좋아요 여부
	public int isBoardLiked(Map<String, Object> paramMap);
	//게시글 좋아요 취소
	public int deleteBoardLike(String fk_id, Long fk_boardNo);
	// 게시물 좋아요
	public int insertBoardLike(String fk_id, Long fk_boardNo);
	//게시글 좋아요 수
	public int getLikeCount(Long boardNo);
	
	// =====================0827 rdg7203 수정 시작 =============================== //
	// 총 검색된 게시물 건수
	public int searchListCount(Map<String, String> paraMap);
	
	// 자동 검색어 완성
	public List<String> getSearchWordList(Map<String, String> paraMap);
	
	// 키워드 테이블에서 데이터 가져오기
	public List<Map<String, Object>> getBoardContents(String category);
	// =====================0827 rdg7203 수정 끝 =============================== //
	
	// 마이페이지 게시글 복구하기
	public int recoveryBoard(String boardNo);




//	// 유저가 하루동안 쓴 글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
//	public int getCreatedAtBoardCnt(String id);
	
}