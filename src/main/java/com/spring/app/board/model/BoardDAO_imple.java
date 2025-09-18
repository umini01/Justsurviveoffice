package com.spring.app.board.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.category.domain.CategoryDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BoardDAO_imple implements BoardDAO {
	
	@Qualifier("sqlsession")
	private final SqlSessionTemplate sql;
	
	// 파일첨부 안 된 게시물 업로드
	@Override
	public int insertBoard(BoardDTO boardDto) {
		return sql.insert("board.insertBoard", boardDto);
	}
	
	// 파일첨부 된 게시물 업로드
	@Override
	public int insertBoardWithFile(BoardDTO boardDto) {
		return sql.insert("board.insertBoardWithFile", boardDto);
	}
	
	// 게시물의 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	@Override
	public List<BoardDTO> selectBoardList(Map<String, String> paraMap) {
		return sql.selectList("board.selectBoardList", paraMap);
	}
	
	// 카테고리별 게시물이 3개씩 있는 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	@Override
	public List<BoardDTO> selectBoardListAll(Map<String, String> paraMap) {
		return sql.selectList("board.selectBoardListAll", paraMap);
	}
	
	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	@Override
	public BoardDTO selectView(Long boardNo) {
		return sql.selectOne("board.selectView", boardNo);
	}
	
	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	@Override
	public int softDeleteBoard(Long boardNo) {
		return sql.update("board.softDeleteBoard", boardNo);
	}
	
	// 게시물 수정하기, 수정시 기존 파일은 삭제!
	@Override
	public int updateBoard(BoardDTO boardDto) {
		return sql.update("board.updateBoard", boardDto);
	}
	
	// 조회수 증가시키기! ip측정 및 스케줄러는 컨트롤러&서비스에서!
	@Override
	public int updateReadCount(Long boardNo) {
		return sql.update("board.updateReadCount", boardNo);
	}

	// 메인페이지 카테고리 리스트 자동 받아오기
	@Override
	public List<CategoryDTO> getIndexList() {
		List<CategoryDTO> IndexList = sql.selectList("board.getIndexList");
		return IndexList;
	}
	
	// 내가 작성한 글 목록 
//  @Override
//  public List<BoardDTO> getMyBoards(String fk_id) {
//  	return sql.selectList("board.getMyBoards", fk_id);
//  }
    
    // 내가 작성한 글 목록 스크롤
    public List<BoardDTO> myBoardsScroll(Map<String, Object> paramMap) {
        return sql.selectList("board.myBoardsScroll", paramMap);
    }
	
	//페이지내이션 
	@Override
	public BoardDTO getView(Long boardNo) {
		return sql.selectOne("board.getView", boardNo);
	}   
	
	// 북마크한 게시글 목록 
    @Override
    public List<BoardDTO> getBookmarksById(String fk_id) {
    	return sql.selectList("board.getBookmarksById", fk_id);
    }

	////////////////////////////////////////////////////////////////////////////
	// 인기 게시글 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> getTopBoardsByViewCount() {
		List<BoardDTO> hotReadList = sql.selectList("board.getTopBoardsByViewCount");
		return hotReadList;
	}
	
	// 댓글 많은 게시글 리스트
	@Override
	public List<BoardDTO> getTopBoardsByCommentCount() {
		List<BoardDTO> hotCommentList = sql.selectList("board.getTopBoardsByCommentCount");
		return hotCommentList;
	}	
	////////////////////////////////////////////////////////////////////////////
	 
	// =====================0827 rdg7203 수정 시작 =============================== //
	// 총 검색된 게시물 건수
	@Override
	public int searchListCount(Map<String, String> paraMap) {
		int n = sql.selectOne("board.searchListCount", paraMap);
		return n;
	}
	
	// 자동 검색어 완성
	@Override
	public List<String> getSearchWordList(Map<String, String> paraMap) {
		List<String> wordList = sql.selectList("board.getSearchWordList", paraMap);
		return wordList;
	}
	
	// 키워드 테이블에서 데이터 가져오기
	@Override
	public List<Map<String, Object>> getBoardContents(String category) {
		List<Map<String, Object>> keyword_top = sql.selectList("board.getBoardContents", category);
		return keyword_top;
	}
	
//	// 유저가 하루동안 쓴 글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
//	@Override
//	public int getCreatedAtBoardCnt(String id) {
//		int n = sql.selectOne("board.getCreatedAtBoardCnt", id);
//		return n;
//	}
	
	

	//게시글 좋아요 여부
	@Override
	public int isBoardLiked(Map<String, Object> paramMap) {
	    return sql.selectOne("boardLike.isBoardLiked", paramMap);
	}
	
	
	
	//게시글 좋아요 추가
	@Override
	public int insertBoardLike(String fk_id, Long fk_boardNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("fk_boardNo", fk_boardNo);
        return sql.insert("boardLike.insertBoardLike", paramMap); 
		
	}
	
	
	 //게시글 좋아요 수
	@Override
	public int getLikeCount(Long boardNo) {
        return sql.selectOne("boardLike.getLikeCount", boardNo);

	}
	
	// 게시글 좋아요 취소
	@Override
	public int deleteBoardLike(String fk_id, Long fk_boardNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("fk_boardNo", fk_boardNo);
		return sql.delete("boardLike.deleteBoardLike", paramMap);
	}
	
	// 마이페이지 게시글 복구하기
	@Override
	public int recoveryBoard(String boardNo) {
		int data = sql.update("board.recoveryBoard", boardNo);
		return data;
	}

}