package com.spring.app.bookmark.service;

import java.util.List;
import java.util.Map;

import com.spring.app.bookmark.domain.BookMarkDTO;

public interface BookmarkService {

    // 북마크 추가
	public int addBookmark(String fk_id, Long fk_boardNo);

    // 북마크 삭제
	public int removeBookmark(String fk_id, Long fk_boardNo);

	// 1개의 게시물에 관련된 모든 북마크 삭제.
	public int removeAllBookmark(Long boardNo);
	
	// 개인의 북마크 리스트 가져오기
	public List<BookMarkDTO> getUserBookmarks(String fk_id);

	public boolean isBookmarked(String fk_id, Long fk_boardNo);


	// 마이페이지 북마크 목록 스크롤
	List<BookMarkDTO> bookmarkScroll(Map<String, Object> paramMap);


    
}