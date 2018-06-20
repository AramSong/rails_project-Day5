## DAY 5

* MVC 패턴에서 각 역할을 단어로 정의.
  * M:  데이터.(애플리케이션의 데이터베이스, 정의하려는 상수, 초기화값, 변수)/데이터를 가공하는 컴포넌트
  * V: 사용자 인터페이스(데이터 및 객체의 입력,출력 담당.클라이언트 쪽의 html,css,javascript)
  * C: 다리( 데이터와 사용자인터페이스 요소들을 잇는 다리 역할. 사용자가 데이터를 클릭하고, 수정하는 것에 대한 "이벤트"들을 처리하는 부분.)

### 다음카페 만들기

* Session(Login)
* controller/model 에서 model 사용하기 + 필터
* Relation(1:n)
* Relation(m:n)

* put과 patch의 차이 (일부 브라우저에서 put을 지원하지 않는 경우, patch를 쓴다)

```
PUT : 자원의 전체 교체, 자원내 모든 필드영역 필요

         (만약 일부만 전달할 경우, 그외의 필드 모두 null or 초기값 처리)

PATCH : 자원의 부분 교체, 자원내 일부 필드영역 필요
```

* restful하게 쓰여진 routes.rb

```ruby
Rails.application.routes.draw do
  root 'board#index'
  
  #전체목록
  get '/board' => 'board#index'
   #새 글 쓰기
  get '/board/new' => 'board#new'
  #글 하나 불러오기
  get '/board/:id' => 'board#show'
  post '/boards' => 'board#create'
  #수정하기
  get '/board/:id/edit' =>'board#edit'
  #몇 번째 글인지 알면 해당 id로 요청 방식만다름.
  patch '/board/:id'  =>'board#update'
  #삭제
  delete '/board/:id' => 'board#destroy'
  
end
```

* rails form helper

```ruby
<%= form_tag("/boards") do %>
    <%= text_field_tag(:title)%>
    <%= text_area_tag(:contents)%>
    <%= submit_tag("작성하기")%>
<% end %>
```

```html
<form action="/caves" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="✓"><input type="hidden" name="authenticity_token" value="Tib7I2q0CQhrj9ensEC3UV4k6eq8UeRARCpykBZPbypHPjxzTSSNmROqEaZmnJsmf7YCZMZXQdSWSfawkZvaEQ==">
    <input type="text" name="title" id="title">
    <textarea name="description" id="description"></textarea>
    <input type="submit" name="commit" value="작성하기" data-disable-with="작성하기">
</form>
```

* 기본적으로 '<a>'태그는 get방식
* rails link_to method :method 를 명시해준다.

```
<%=link_to "삭제","/board/#{@post.id}" method:"delete"%>
```

### 간단과제

* BoardController는 완성

* User 모델과 UserController CRUD

  * columns: user_id,password,ip_address	

  ```
  $ rails g model User
  $ rake db:migrate
  $ rails g controller User edit index sign_up show
  ```

  * delete는 없음
  * /user/new => /sign_up

* Cafe 모델과 CafeController CRUD

  * columns: title,description

  ```
  $ rails g controller Cafe
  $ rake db:migrate
  ```

  

* View까지

### 쿠키와 세션

* cookies  : 독립적인 request와 response가 이어진다. 어떤 정보를 지속적으로 유지하기 위해서 클라이언트(브라우저)쪽에 정보를 저장. 요청마다 쿠키라는 정보를 계속적으로 같이 보낸다. 클라이언트쪽에 정보가 유지되다보면 위조나 해킹당할 수가 있다.
* session :  정보를 server의 memory에 저장. 클라이언트에는 session id를 저장한다. 즉, 정보 자체의 내용은 서버에 위치는 클라이언트에 저장. 

***"정보가 서버에 있는게 세션, 클라이언트에 있는게 쿠키. 클라이언트에 정보의 위치(session_id)를 저장하는게 세션"***

=> 세션은 접속하는 사람마다 독립적으로 따로 있다. 공유를 하는 것이 아닌 접속한 사람당 하나의 세션이 계속적으로 생긴다

### 로그인

```ruby
  def index
    @Users = User.all
    @login_user = User.find(session[:user_id]) if session[:user_id]
  end
 def sign_in
    #세션을 지운다.
    session.delete(:user_id)
  end
  
  def login
      #user_id column을 이용하여 검색
    user = User.find_by_user_id(params[:user_id])
    if !user.nil? and user.password.eql?(params[:password])
      # user가 있고, 비밀번호가 맞는 경우
      flash[:success] = "로그인 되었습니다."
      session[:user_id] = user.id
      redirect_to '/users'
    else
      # user 비어있거나, 비밀번호가 틀린 경우
      flash[:error] = "등록되지 않은 ID거나, 비밀번호가 일치하지 않습니다."
      redirect_to '/sign_in'
    end
  end
```

