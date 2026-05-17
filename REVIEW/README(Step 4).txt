🚀 Step 3.5 & 4 통합 복기: "데이터의 완성"
이번 단계는 단순히 기능을 넣는 걸 넘어, 
CRUD(생성, 조회, 수정, 삭제)의 완성도를 높이고 
멀티미디어(이미지)를 다루기 시작했다는 점에서 의미가 커.


🛠️ 추가된 핵심 기능 및 로직 정리

X) 기능 
> 핵심 도구 (Package)	
+ 로직 요약

1) 게시글 삭제	
> cloud_firestore	
+ doc(docId).delete()를 호출해 서버에서 즉시 제거. 
  삭제 전 AlertDialog로 사용자 확인.

2) 이미지 선택	
> image_picker	
+ ImageSource.gallery를 통해 내 폰의 사진첩을 열고 파일(File)로 가져옴.  

3) 이미지 업로드	
> firebase_storage	
+ 고른 파일을 putFile()로 서버 전송. 고유한 주소(DownloadURL)를 따옴.

4) 이미지 연동	
> Firestore + Storage	
+ 받아온 사진 주소(URL)를 Firestore 문서의 imageUrl 필드에 텍스트로 저장.

5) 이미지 출력	
> Image.network()	
+ 저장된 URL을 읽어와서 리스트와 상세 페이지에 실제 사진으로 렌더링.


🧠 민규를 위한 기술 포인트 (복습!)

1. 데이터 전달의 연쇄: 
> 리스트에서 글을 누를 때 
  내용(data)과 이름표(docId)를 함께 넘겨줘야 상세 페이지에서 '삭제'나 '수정'을 할 수 있다는 걸 배웠어.

2. 비동기 처리(Async/Await)
> 사진을 올리거나 글을 지우는 건 시간이 걸리는 '배달' 작업이야. 
  그래서 await를 써서 작업이 끝날 때까지 기다려주는 게 필수야.

3. 조건부 렌더링 (Conditional Rendering)
> if (data['imageUrl'] != null) 코드를 통해 사진이 있는 글은 예쁘게 사진을 보여주고, 
  없는 글은 텍스트만 보여주도록 예외 처리를 완벽하게 했어.