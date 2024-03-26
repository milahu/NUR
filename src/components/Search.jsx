import { $, component$, useStylesScoped$ } from '@builder.io/qwik';










export const Search = component$(( props) => {
  useStylesScoped$(AppCSS);

  const setSearchBy = $((e) => {
    console.log(e.target.value)
    props.searchBy.value = e.target.value;
  })

  const setSearchInp = $((e) => {
    props.searchInp.value = e.target.value;
  })

  return (
    <div class='search-cont'>
      Search by
      <select onInput$={setSearchBy}>
        {props.headers.map((item, i) => (
          <option key={i}>{item.key}</option>
        ))}
        </select>
      <input onInput$={setSearchInp} class='search-inp' placeholder='search' />
    </div>
  );
});

export const AppCSS = `
  .search-inp {
    outline: none;
    border: 1px solid #e2e8f0;
    width: 240px;
    height: 40px;
    border-radius: 8px;
    font-size: 15px;
    margin-left: 15px;
    padding-left: 10px;
    padding-right: 10px;
  }
  .search-inp:focus {
    outline: 2px solid #19b6f6;
  }
  select {
    outline: none;
    margin-left: 10px;
    width: 100px;
    height: 40px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
  }
  select:focus {
    outline: 2px solid #19b6f6;
  }
`;
