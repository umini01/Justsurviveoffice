package com.spring.app.bookmark.model;

import java.util.List;
import java.util.Map;

import com.spring.app.bookmark.domain.BookMarkDTO;

public interface BookmarkDAO {

    // 북마크 추가
    int addBookmark(String fk_id,Long fk_boardNo);

    // 북마크 삭제
    int removeBookmark( String fk_id, Long fk_boardNo);

    // 1개의 게시물에 관련된 모든 북마크 삭제.
	int removeAllBookmark(Long boardNo);
	
    // 북마크 여부 체크
    int checkBookmark(String fk_id,  Long fk_boardNo);

    // 북마크 목록 조회
    List<BookMarkDTO> getUserBookmarks(String fk_id);

    // 마이페이지 북마크 목록 스크롤
	List<BookMarkDTO> bookmarkScroll(Map<String, Object> paramMap);
	
}