{React, ReactBootstrap, jQuery, config} = window
{Panel, Button, Col, Input, Grid, Row, ButtonGroup, DropdownButton, MenuItem, Table} = ReactBootstrap
Divider = require './divider'

AkashicRecordsCheckboxArea = React.createClass
  getInitialState: ->
    topPaneShow: true
    searchNum: 0
    filterKeys:['']
    searchResult:[
      result: 0
      num: 0
      percent: 0
    ]
  handlePaneShow: ->
    {topPaneShow} = @state
    topPaneShow = not topPaneShow
    @setState {topPaneShow}
  handleClickCheckbox: (index) ->
    {rowChooseChecked} = @props
    rowChooseChecked[index] = !rowChooseChecked[index]
    @props.tabFilterRules rowChooseChecked
    config.set "plugin.Akashic.#{@props.contentType}.checkbox", JSON.stringify rowChooseChecked
  handleClickConfigCheckbox: (index) ->
    @props.configCheckboxClick index
  handleShowAmountSelect: (selectedKey)->
    @props.showRules selectedKey, @props.activePage
  handleShowPageSelect: (selectedKey)->
    @props.showRules @props.showAmount, selectedKey
  handleKeyWordChange: (selectedKey)->
    test = 1
  render: ->
    <div className='akashic-records-settings' className={if @state.topPaneShow then "tap-pane-show" else "tab-pane-hidden"}>
      <Grid>
        <Row>
          <Col xs={12}>
            <div onClick={@handlePaneShow}>
              <Divider text="筛选与统计" icon={true} show={@state.topPaneShow}/>
            </div>
          </Col>
        </Row>
      </Grid>
      <Grid className='akashic-records-filter' style={if @state.topPaneShow then {display: 'block'} else {display: 'none'} }>
        <Row>
        {
          for checkedVal, index in @props.tableTab
            continue if !index
            <Col key={index} xs={2}>
              <Input type='checkbox' value={index} onChange={@handleClickCheckbox.bind(@, index)} checked={@props.rowChooseChecked[index]} style={verticalAlign: 'middle'} label={checkedVal} />
            </Col>
        }
        </Row>
        <hr/>
        <Row>
          <Col xs={2}>
            <ButtonGroup justified>
              <DropdownButton bsSize='xsmall' center eventKey={4} title={"显示#{@props.showAmount}条"} block>
                <MenuItem center eventKey=10 onSelect={@handleShowAmountSelect}>{"显示10条"}</MenuItem>
                <MenuItem eventKey=20 onSelect={@handleShowAmountSelect}>{"显示20条"}</MenuItem>
                <MenuItem eventKey=50 onSelect={@handleShowAmountSelect}>{"显示50条"}</MenuItem>
                <MenuItem divider />
                <MenuItem eventKey=999999 onSelect={@handleShowAmountSelect}>{"显示全部"}</MenuItem>
              </DropdownButton>
            </ButtonGroup>
          </Col>
          <Col xs={2}>
            <ButtonGroup justified>
              <DropdownButton bsSize='xsmall' eventKey={4} title={"第#{@props.activePage}页"} block>
              {
                if @props.dataShowLength isnt 0
                  for index in [1..Math.ceil(@props.dataShowLength/@props.showAmount)]
                    <MenuItem eventKey={index} onSelect={@handleShowPageSelect}>第{index}页</MenuItem>
              } 
              </DropdownButton>
            </ButtonGroup>
          </Col>
          <Col xs={5}>
          {
            for checkedVal, index in @props.configList
              continue if index is 3
              <Col key={index} xs={4}>
                <Input type='checkbox' value={index} onChange={@handleClickConfigCheckbox.bind(@, index)} checked={@props.configChecked[index]} style={verticalAlign: 'middle'} label={checkedVal} />
              </Col>
          }
          </Col>
          <Col xs={3}>
          {
            index = 3
            checkedVal = @props.configList[index]
            <Input type='checkbox' value={index} onChange={@handleClickConfigCheckbox.bind(@, index)} checked={@props.configChecked[index]} style={verticalAlign: 'middle'} label={checkedVal} />
          }
          </Col>
        </Row>
        <Row>
          <Col xs={12}>
            <Table bordered responsive>
              <thead>
                <tr>
                  <th style={verticalAlign: 'middle'}><FontAwesome name='question-circle'/></th>
                  <th>关键词</th>
                  <th>命中数</th>
                  <th>总样本</th>
                  <th>百分比</th>
                </tr>
              </thead>
              <tbody>
              {
                for index in [0..@state.searchNum]
                  <tr>
                    {
                      if index is 0
                        <td style={verticalAlign: 'middle'}><FontAwesome name='plus-circle'/></td>
                      else
                        <td style={verticalAlign: 'middle'}><FontAwesome name='minus-circle'/></td>
                    }
                    <td>
                       <Input
                          type='text'
                          value={@state.filterKeys[index]}
                          placeholder={"关键词"}
                          ref="search#{index}"
                          groupClassName='search-area'
                          onChange={@handleKeyWordChange} />
                    </td>
                    <td>{@state.searchResult[index]['result']}</td>
                    <td>{@state.searchResult[index]['num']}</td>
                    <td>{"#{@state.searchResult[index]['percent']}%"}</td>
                  </tr>
              }
              </tbody>
            </Table>
          </Col>
        </Row>
      </Grid>
    </div>

module.exports = AkashicRecordsCheckboxArea
