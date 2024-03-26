import { component$, useSignal, useStylesScoped$, $, useComputed$ } from '@builder.io/qwik';







export const Pagination = component$((props) => {
  useStylesScoped$(AppCSS);

  const totalPage = useComputed$(() => {
    return Math.ceil((props.totalPosts.value / props.postPerPage.value)) || 1;
  });

  const decPage = $(() => {
    if (props.pageNo.value > 1) props.pageNo.value--;
  })

  const incPage = $(() => {
    if (props.pageNo.value < totalPage.value) props.pageNo.value++;
  })

  const setFirstPage = $(() => {
    if(props.pageNo.value !== 1) props.pageNo.value = 1;
  })

  const setLastPage = $(() => {
    if(props.pageNo.value !== totalPage.value) props.pageNo.value = totalPage.value;
  })

  const postPerPageLast = useSignal(props.postPerPage.value);

  const postPerPageChange = $(() => {
    // scale pageNo to keep the first row in focus
    const firstRowIdx = postPerPageLast.value * (props.pageNo.value - 1);
    const totalPage2 = Math.ceil((props.totalPosts.value / props.postPerPage.value)) || 1;
    const pageNo2 = Math.floor(Math.min(totalPage2, (firstRowIdx / props.postPerPage.value) + 1));
    //console.log(`postPerPage: ${postPerPageLast.value} -> ${props.postPerPage.value}`);
    //console.log(`totalPage: ${totalPage.value} -> ${totalPage2}`);
    //console.log(`firstRowIdx: ${firstRowIdx}`);
    //console.log(`pageNo: ${props.pageNo.value} -> ${pageNo2}`);
    props.pageNo.value = pageNo2;
    postPerPageLast.value = props.postPerPage.value;
  });

  return (
    <div class='page-cont'>

      <div class='post-select'>
        <div>Rows per page </div>
        <select bind:value={props.postPerPage} onChange$={postPerPageChange}>
          {props.postPerPageValues.map((postPerPage, idx) => (
            <option key={idx} selected={postPerPage == props.postPerPage.value}>{postPerPage}</option>
          ))}
        </select>
      </div>

      <div>
        <div class='select-page'>Page <input bind:value={props.pageNo} type='number' min={1} max={totalPage.value} /> of {totalPage.value}</div>
      </div>

      <div class='btn-cont'>
        <button disabled={props.pageNo.value === 1} onClick$={setFirstPage}>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><polyline points="11 17 6 12 11 7"></polyline><polyline points="18 17 13 12 18 7"></polyline></svg>
        </button>
        <button onClick$={decPage}>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><polyline points="15 18 9 12 15 6"></polyline></svg>
        </button>
        <button onClick$={incPage}>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><polyline points="9 18 15 12 9 6"></polyline></svg>
        </button>
        <button disabled={props.pageNo.value === totalPage.value} onClick$={setLastPage}>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><polyline points="13 17 18 12 13 7"></polyline><polyline points="6 17 11 12 6 7"></polyline></svg>
        </button>
      </div>
    </div>
  );
});

export const AppCSS = `
  .post-select {
    display: flex;
    align-items: center;
    gap: 10px;
  }
  select {
    outline: none;
    width: 50px;
    height: 30px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
  }
  select:focus {
    outline: 2px solid #19b6f6;
  }
  .select-page>input {
    outline: none;
    border: 1px solid #e2e8f0;
    width: 50px;
    height: 30px;
    border-radius: 8px;
    font-size: 14px;
  }
  .select-page>input:focus {
    outline: 2px solid #19b6f6;
  }
  .btn-cont>button:focus {
    outline: 2px solid #19b6f6;
  }
  .page-cont {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 40px;
  }
  .btn-cont {
    height: 80px;
    display: flex;
    align-items: center;
    gap: 10px;
  }
  button {
    height: fit-content;
    background: transparent;
    border: 1px solid #e2e8f0;
    cursor: pointer;
    border-radius: 8px;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  button:disabled {
    cursor: not-allowed;
  }
  button:hover {
    background: #f8f9fb;
  }
`;
