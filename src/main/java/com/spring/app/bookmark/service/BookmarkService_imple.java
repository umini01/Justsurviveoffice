package com.spring.app.bookmark.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

import com.spring.app.bookmark.domain.BookMarkDTO;
import com.spring.app.bookmark.model.BookmarkDAO;

@Service
@RequiredArgsConstructor
public class BookmarkService_imple implements BookmarkService {

    private final BookmarkDAO bookmarkDao;
    
    // 북마크 추가
    @Override
    public int addBookmark(String fk_id, Long fk_boardNo) {
    	return bookmarkDao.addBookmark(fk_id, fk_boardNo);
    }
    // 북마크 삭제
    @Override
    public int removeBookmark(String fk_id, Long fk_boardNo) {
        return bookmarkDao.removeBookmark(fk_id, fk_boardNo);
    }

    // 1개의 게시물에 관련된 모든 북마크 삭제.
 	@Override
 	public int removeAllBookmark(Long boardNo) {
 		return bookmarkDao.removeAllBookmark(boardNo);
 	}

 	// 개인의 북마크 리스트 가져오기
    @Override
    public List<BookMarkDTO> getUserBookmarks(String fk_id) {
        return bookmarkDao.getUserBookmarks(fk_id);
    }

    @Override
    public boolean isBookmarked(String fk_id, Long fk_boardNo) {
        return bookmarkDao.checkBookmark(fk_id, fk_boardNo) > 0;
    }

 // 마이페이지 북마크 목록 스크롤
    @Override
    public List<BookMarkDTO> bookmarkScroll(Map<String, Object> paramMap) {
        return bookmarkDao.bookmarkScroll(paramMap);
    }

}